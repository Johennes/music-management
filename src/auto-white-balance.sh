#!/bin/bash

# Usage Info

function usage {
    echo "Usage: auto-white-balance.sh directory"
    echo ""
    echo "Uses GIMP batch mode to peform an automatic white balance"
    echo "operation (which effectively is an RGB level stretch) on all"
    echo "TIF image files in the specified directory. Files are"
    echo "modified in place."
    echo ""
    echo "This script relies on the presence of the accompanying SCM"
    echo "script in the user's GIMP scripts folder. If it hasn't been"
    echo "installed yet, the script offers to link it."
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

# Script Installation

SCRIPT_DIR=~/.gimp-2.8/scripts
SCRIPT_NAME=auto-white-balance.scm
SCRIPT=${SCRIPT_DIR}/${SCRIPT_NAME}

if [[ ! -e "${SCRIPT}" ]]; then
    echo "Error: Script not installed under ${SCRIPT_DIR}"
    echo -n "Do you want to link it? [y/n]: "

    read RESPONSE

    if [[ "${RESPONSE}" != y ]]; then
        echo "Error: Cannot run without installed script"
        exit 1
    fi

    SOURCE=$(cd "$(dirname "$0")"; pwd -P)/${SCRIPT_NAME}
    if [[ ! -f "${SOURCE}" ]]; then
        echo "Error: Could not locate script source file ${SOURCE}"
        exit 1
    fi

    ln -vs "${SOURCE}" "${SCRIPT}"
fi

# File Processing

DIR=$(cd "$1"; pwd -P)

echo "Processing files in ${DIR}..."

pushd "${DIR}" > /dev/null
gimp -i -b '(batch-auto-white-balance "*.tif")' -b '(gimp-quit 0)'
popd > /dev/null
