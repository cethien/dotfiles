package main

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"

	"github.com/cethien/tmux-launcher/modules/module_ssh"
	"github.com/cethien/tmux-launcher/modules/module_toml"
	"github.com/urfave/cli/v3"
)

func runLauncher(configPath string, selfBin string) error {
	registry := buildRegistry(configPath, selfBin)

	allEntries, err := registry.CollectAllEntries()
	if err != nil || len(allEntries) == 0 {
		return nil
	}

	history := LoadHistory()
	sort.SliceStable(allEntries, func(i, j int) bool {
		return history.GetScore(allEntries[i].Name) > history.GetScore(allEntries[j].Name)
	})

	fzf := NewFzfRunner("launch")
	selectedEntry, err := fzf.Select(allEntries)
	if err != nil || selectedEntry == nil {
		return nil
	}

	history.RecordUse(selectedEntry.Name)

	if os.Getenv("TMUX") != "" {
		tmuxCmd := exec.Command("tmux", "new-window", "-n", selectedEntry.WindowTitle, selectedEntry.ExecCmd)
		return tmuxCmd.Run()
	}

	shCmd := exec.Command("sh", "-c", selectedEntry.ExecCmd)
	shCmd.Stdout = os.Stdout
	shCmd.Stdin = os.Stdin
	shCmd.Stderr = os.Stderr
	return shCmd.Run()
}

func buildRegistry(configPath string, selfBin string) *Registry {
	registry := NewRegistry()
	registry.Register(module_toml.New(configPath, selfBin))
	registry.Register(module_ssh.New(selfBin))
	return registry
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
				Usage: "Render preview for a specific module target",
				Flags: []cli.Flag{
					&cli.StringFlag{
						Name:     "module",
						Aliases:  []string{"m"},
						Required: true,
						Usage:    "Target module name",
					},
					&cli.StringFlag{
						Name:     "target",
						Aliases:  []string{"t"},
						Required: true,
						Usage:    "Target payload for the preview renderer",
					},
					&cli.StringFlag{
						Name:    "config",
						Aliases: []string{"c"},
						Value:   defaultCfg,
					},
				},
				Action: func(ctx context.Context, cmd *cli.Command) error {
					modName := cmd.String("module")
					target := cmd.String("target")

					registry := buildRegistry(cmd.String("config"), selfBin)
					mod := registry.GetModule(modName)
					if mod == nil {
						return fmt.Errorf("module '%s' not registered", modName)
					}

					return mod.RenderPreview(target)
				},
			},
		},
	}

	if err := cmd.Run(context.Background(), os.Args); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
