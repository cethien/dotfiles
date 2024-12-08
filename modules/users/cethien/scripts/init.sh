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

if [ "$1" = "go" ]; then
    if ! command -v go &>/dev/null; then
        echo "go could not be found"
        echo "please install go"
        exit 1
    fi
fi

if [ $# -eq 1 ]; then
    if [ "$1" = "go" ]; then
        echo "no module name provided"
        return 1
    elif [ "$1" = "svelte" ]; then
        echo "no project name provided"
        return 1
    else
        mkdir "$1" && cd "$_" &&
            git clone https://github.com/cethien/template.git . &>/dev/null &&
            rm -rf .git &&
            edit README.md &&
            git_init
        return 0
    fi
elif [ $# -eq 2 ]; then
    if [ "$1" = "go" ]; then
        if ! command -v gonew &>/dev/null; then
            echo "gonew could not be found"
            echo "installing"
            go install golang.org/x/tools/cmd/gonew@latest
        fi

        gonew github.com/cethien/template-go@latest "$2" &&
            module_name=$(basename "$2") &&
            trimmed_module_name=$(echo "$module_name" | sed 's/[-_]//g') &&
            command cd "$module_name" || exit

        # Extract the owner and repo from the Go module path (assumed format: github.com/{owner}/{repo})
        owner=$(echo "$2" | awk -F/ '{print $2}')

        command find . -type f -exec sed -i "s/template-go/$module_name/g" {} + &&
            command find . -type f -exec sed -i "s/templatego/$trimmed_module_name/g" {} + &&
            mv cmd/template-go cmd/"$module_name" &&
            sed -i "s|ghcr.io/owner/{{ .ProjectName }}:latest|ghcr.io/$owner/{{ .ProjectName }}:latest|" .goreleaser.yml &&
            sed -i "s|ghcr.io/owner/{{ .ProjectName }}:{{ .Tag }}|ghcr.io/$owner/{{ .ProjectName }}:{{ .Tag }}|" .goreleaser.yml &&
            edit README.md &&
            git_init
        return 0
    elif [ "$1" = "svelte" ]; then
        git clone https://github.com/cethien/template-sveltekit.git "$2" &&
            command cd "$2" || exit

        edit README.md &&
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
