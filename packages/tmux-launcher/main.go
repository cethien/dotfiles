package main

import (
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/urfave/cli/v3"
)

func runLauncher(configPath string, selfBin string) error {
	registry := NewRegistry()
	registry.Register(NewTomlModule(configPath, selfBin))
	registry.Register(NewSshModule(selfBin))
	registry.Register(NewDockerModule(selfBin))

	allEntries, err := registry.CollectAllEntries()
	if err != nil || len(allEntries) == 0 {
		return nil
	}

	var inputBuf bytes.Buffer
	for _, e := range allEntries {
		inputBuf.WriteString(e.ToFzfLine() + "\n")
	}

	fzfCmd := exec.Command(
		"fzf",
		"--cycle",
		"--prompt=launch > ",
		"--delimiter=\t",
		"--with-nth=1",
		"--preview=eval {4}",
		"--preview-window=right:65%",
	)
	fzfCmd.Stdin = &inputBuf
	fzfCmd.Stderr = os.Stderr

	out, err := fzfCmd.Output()
	if err != nil || len(out) == 0 {
		return nil
	}

	selected := strings.TrimSpace(string(out))
	parts := strings.Split(selected, "\t")
	if len(parts) < 3 {
		return nil
	}

	windowTitle := parts[1]
	execCmd := parts[2]

	if os.Getenv("TMUX") != "" {
		tmuxCmd := exec.Command("tmux", "new-window", "-n", windowTitle, execCmd)
		return tmuxCmd.Run()
	}

	shCmd := exec.Command("sh", "-c", execCmd)
	shCmd.Stdout = os.Stdout
	shCmd.Stdin = os.Stdin
	shCmd.Stderr = os.Stderr
	return shCmd.Run()
}

func main() {
	selfBin, err := os.Executable()
	if err != nil {
		selfBin = os.Args[0]
	}

	home, _ := os.UserHomeDir()
	defaultCfg := filepath.Join(home, ".config", "tmux", "launcher.toml")

	cmd := &cli.Command{
		Name:  "tmux-launcher",
		Usage: "TUI Launcher via fzf for tmux windows",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:    "config",
				Aliases: []string{"c"},
				Value:   defaultCfg,
				Usage:   "Path to TOML launcher config",
			},
		},
		Action: func(ctx context.Context, cmd *cli.Command) error {
			return runLauncher(cmd.String("config"), selfBin)
		},
		Commands: []*cli.Command{
			{
				Name:  "launch",
				Usage: "Trigger fzf launcher menu",
				Flags: []cli.Flag{
					&cli.StringFlag{
						Name:    "config",
						Aliases: []string{"c"},
						Value:   defaultCfg,
						Usage:   "Path to TOML launcher config",
					},
				},
				Action: func(ctx context.Context, cmd *cli.Command) error {
					return runLauncher(cmd.String("config"), selfBin)
				},
			},
			{
				Name:  "preview",
				Usage: "Preview providers for fzf",
				Commands: []*cli.Command{
					{
						Name:  "ssh",
						Usage: "Preview for SSH host",
						Flags: []cli.Flag{
							&cli.StringFlag{
								Name:     "host",
								Aliases:  []string{"H"},
								Required: true,
								Usage:    "SSH host name",
							},
						},
						Action: func(ctx context.Context, cmd *cli.Command) error {
							return RunPreviewSsh(cmd.String("host"))
						},
					},
					{
						Name:  "docker",
						Usage: "Preview for Docker containers on host",
						Flags: []cli.Flag{
							&cli.StringFlag{
								Name:     "host",
								Aliases:  []string{"H"},
								Required: true,
								Usage:    "SSH host name",
							},
						},
						Action: func(ctx context.Context, cmd *cli.Command) error {
							return RunPreviewDocker(cmd.String("host"))
						},
					},
					{
						Name:  "text",
						Usage: "Preview for markdown text",
						Flags: []cli.Flag{
							&cli.StringFlag{Name: "b64", Required: true},
						},
						Action: func(ctx context.Context, cmd *cli.Command) error {
							return RunPreviewText(cmd.String("b64"))
						},
					},
					{
						Name:  "empty",
						Usage: "Fallback preview for empty entries",
						Flags: []cli.Flag{
							&cli.StringFlag{Name: "kaomoji"},
						},
						Action: func(ctx context.Context, cmd *cli.Command) error {
							return RunPreviewEmpty(cmd.String("kaomoji"))
						},
					},
				},
			},
		},
	}

	if err := cmd.Run(context.Background(), os.Args); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
