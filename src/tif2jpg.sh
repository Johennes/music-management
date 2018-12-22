#!/bin/bash

# Usage Info

function usage {
    echo "Usage: tif2jpg.sh directory"
    echo ""
    echo "Uses ImageMagick to convert TIFs to JPGs in the specified"
    echo "directory. If confirmed, the JPGs are removed again at the"
    echo "end."
    echo ""
    echo "  -h    Show this message and exit"
}

# CLI Option Handling

while getopts ":h" OPT; do
    case "${OPT}" in
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

if [[ $(ls "$1" | grep -c \\.tif) -lt 1 ]]; then
    echo "Error: No TIF files found in $1"
    exit 1
fi

# File Processing

JPGS=()

for TIF in *.tif; do
    echo "Processing ${TIF}..."

    JPG=$(basename "${TIF}" .tif).jpg

    if [[ -e "${JPG}" ]]; then
        echo "Error: ${JPG} already exists, skipping TIF"
        continue
    fi

    convert "${TIF}" "${JPG}"
    JPGS+=("${JPG}")
done

if [[ "${#JPGS[@]}" -eq 0 ]]; then
    exit 0
fi

echo -n "Delete JPGs? [y/n]: "
read RESPONSE

if [[ "${RESPONSE}" != y ]]; then
    exit 0
fi

for JPG in "${JPGS[@]}"; do
    echo "Removing ${JPG}..."
    rm "${JPG}"
done
