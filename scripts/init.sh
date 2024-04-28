#!/bin/bash

function git_init() {
    git init && git add . && git commit -m "chore: init"
}

if [ $# -eq 1 ]; then
    if [ "$1" = "go" ]; then
        echo "no module name provided"
        return 1
    else
        mkdir "$1" && cd "$_" && touch README.md .gitignore && \
        git_init
        return 0
    fi
elif [ $# -eq 2 ]; then
    if [ "$1" = "go" ]; then
        gonew github.com/cethien/template-go@latest $2 && \
        module_name=$(basename "$2") && \
        cd "$module_name"
        # \find . -type f -exec sed -i "s/template/$module_name/g" {} + && \
        # mv template.go "$module_name.go" && \
        # git_init
        return 0
    else
        echo "Illegal number of parameters"
        return 1
    fi
else
    echo "Illegal number of parameters"
    return 1
fi
