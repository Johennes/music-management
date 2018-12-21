#!/bin/bash

# Usage Info

function usage {
    echo "Usage: add-replay-gain.sh [-f] directory"
    echo ""
    echo "Recursively walks over the specified directory and its"
    echo "subdirectories and adds ReplayGain tags to FLACs in every"
    echo "folder. If all files in a given folder are already tagged,"
    echo "the folder is skipped (unless -f is specified)."
    echo ""
    echo "  -f    Force recalculation and overwrite existing tags"
    echo "  -h    Show this message and exit"
}

# CLI Option Handling

FORCE=false

while getopts ":hf" OPT; do
    case "${OPT}" in
        f)
            FORCE=true
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

if [[ -z "$1" ]]; then
    echo "Error: No directory specified"
    echo ""
    usage
    exit 1
fi

if [[ ! -d "$1" ]]; then
    echo "Error: No such directory $1"
    echo ""
    usage
    exit 1
fi

# File Processing

while read -r DIR; do
    if [[ $(ls "${DIR}" | grep -c \\.flac) -lt 1 ]]; then
        continue
    fi

    echo "Processing ${DIR}..."

    if ! ${FORCE}; then
        echo "Checking existing ReplayGain tags..."
        UNTAGGED=false
        while read -r FILE; do
            TRACK=$(metaflac --show-tag=REPLAYGAIN_TRACK_GAIN "${FILE}")
            ALBUM=$(metaflac --show-tag=REPLAYGAIN_ALBUM_GAIN "${FILE}")
            if [[ -z  "${TRACK}" || -z "${ALBUM}" ]]; then
                UNTAGGED=true
                break
            fi
        done < <(find "${DIR}" -maxdepth 1 -name "*.flac")

        if ! ${UNTAGGED}; then
            echo "All files already tagged, skipping directory"
            continue
        fi

        echo "Untagged files found, calculating ReplayGain values..."
    else
        echo "Force-recalculating ReplayGain values..."
    fi

    metaflac --add-replay-gain "${DIR}"/*.flac

    while read -r FILE; do
        echo "Computed ReplayGain values for ${FILE}:"
        metaflac --show-tag=REPLAYGAIN_TRACK_GAIN "${FILE}"
        metaflac --show-tag=REPLAYGAIN_ALBUM_GAIN "${FILE}"
    done < <(find "${DIR}" -maxdepth 1 -name "*.flac")
done < <(find -L "$1" -type d)
