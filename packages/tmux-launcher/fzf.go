package main

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/cethien/tmux-launcher/types"
)

type FzfRunner struct {
	Prompt string
}

func NewFzfRunner(prompt string) *FzfRunner {
	return &FzfRunner{Prompt: prompt}
}

func (f *FzfRunner) Select(entries []types.Entry) (*types.Entry, error) {
	if len(entries) == 0 {
		return nil, nil
	}

	var inputBuf bytes.Buffer
	for _, e := range entries {
		inputBuf.WriteString(e.ToFzfLine())
		inputBuf.WriteByte('\n')
	}

	fzfCmd := exec.Command(
		"fzf",
		"--cycle",
		fmt.Sprintf("--prompt=%s > ", f.Prompt),
		"--delimiter=\t",
		"--with-nth=1",
		"--preview=eval {4}",
		"--preview-window=right:65%",
	)
	fzfCmd.Stdin = &inputBuf
	fzfCmd.Stderr = os.Stderr

	out, err := fzfCmd.Output()
	if err != nil || len(out) == 0 {
		return nil, nil
	}

	selected := strings.TrimSpace(string(out))
	parts := strings.Split(selected, "\t")
	if len(parts) < 5 {
		return nil, nil
	}

	selectedName := parts[4]

	for i := range entries {
		if entries[i].Name == selectedName {
			return &entries[i], nil
		}
	}

	return nil, nil
}
