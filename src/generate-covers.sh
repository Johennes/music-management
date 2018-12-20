#!/bin/bash

# Usage Info

function usage {
    echo "Usage: generate-covers"
    echo ""
    echo "Recursively walks over the specified directory and its"
    echo "subdirectories and creates cover.jpg files from artwork TIFs."
    echo "Only the first matching TIF in each folder is used. If a"
    echo "cover JPG already exists in a given folder, the folder is"
    echo "skipped (unless -f is specified)."
    echo ""
    echo "  -f    Force regeneration and overwrite existing JPGs"
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
    if [[ $(ls "${DIR}" | grep -c \\.tif) -lt 1 ]]; then
        continue
    fi

    echo "Processing ${DIR}..."

    if ! ${FORCE} && [[ -f "${DIR}/cover.jpg" ]]; then
        echo "Cover already exists, skipping directory"
    else
        CONVERTED=false
        for TIF in "${DIR}"/*.tif; do
            if [[ -f "${TIF}" && "${TIF}" =~ .*(booklet|cover|front).* ]]; then
                echo "Converting ${TIF}..."
                convert "${TIF}" "${DIR}/cover.jpg"
                CONVERTED=true
                break
            fi
        done
        if ! ${CONVERTED}; then
            echo "No cover art TIF found, skipping directory"
        fi
    fi
done < <(find -L "$1" -type d)
