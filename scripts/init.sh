#!/bin/bash

function git_init() {
    git init && git add . && git commit -m "chore: init"
}

function edit() {
    for file in "$@"; do
        if [ -f "$file" ]; then
            $EDITOR "$file"
        fi
    done
}

if [ $# -eq 1 ]; then
    if [ "$1" = "go" ]; then
        echo "no module name provided"
        return 1
    else
        mkdir "$1" && cd "$_" && touch README.md .gitignore && \
        edit README.md && \
        git_init
        return 0
    fi
elif [ $# -eq 2 ]; then
    if [ "$1" = "go" ]; then
        gonew github.com/cethien/template-go@latest $2 && \
        module_name=$(basename "$2") && \
        trimmed_module_name=$(echo "$module_name" | sed 's/[-_]//g') && \
        command cd "$module_name"
        command find . -type f -exec sed -i "s/template-go/$module_name/g" {} + && \
        command find . -type f -exec sed -i "s/templatego/$trimmed_module_name/g" {} + && \
        mv template-go.go "$module_name.go" && \
        mv cmd/template-go cmd/"$module_name" && \
        edit README.md .goreleaser.yml && \
        git_init
        return 0
    else
        echo "Illegal number of parameters"
        return 1
    fi
else
    echo "Illegal number of parameters"
    return 1
fi
