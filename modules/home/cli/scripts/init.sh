#!/usr/bin/env bash

usage() {
    echo "Usage: $0 [options] <dest>"
    echo ""
    echo "Parameters:"
    echo "  <dest>  Destination directory for the new project"
    echo ""
    echo "Options:"
    echo "  -t, --template <variant>  Specific variant for the template, e.g., 'svelte' or 'go'"
    echo "  -h, --help                Show this help message"
    exit 1
}

TEMPLATE_VARIANT=""

while [[ $# -gt 0 ]]; do
    case "$1" in
    -t | --template)
        TEMPLATE_VARIANT="$2"
        shift 2
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        DESTINATION="$1"
        shift
        ;;
    esac
done

if [[ -z $DESTINATION ]]; then
    echo "Error: destination cannot be empty"
    usage
fi

if [[ -n $TEMPLATE_VARIANT ]]; then
    TEMPLATE="github:cethien/templates#$TEMPLATE_VARIANT"
else
    TEMPLATE="github:cethien/templates"
fi

nix flake new -t "$TEMPLATE" "$DESTINATION"
cd "$DESTINATION" || exit
