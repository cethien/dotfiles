package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/charmbracelet/lipgloss"
	"github.com/muesli/termenv"
)

type DockerModule struct {
	SelfBin string
}

func NewDockerModule(selfBin string) *DockerModule {
	return &DockerModule{SelfBin: selfBin}
}

func (m *DockerModule) Name() string {
	return "docker"
}

func (m *DockerModule) GetEntries() ([]Entry, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return nil, err
	}

	cfgPath := filepath.Join(home, ".ssh", "config")
	file, err := os.Open(cfgPath)
	if err != nil {
		return nil, nil
	}
	defer file.Close()

	var dockerHosts []string
	var currentHost string
	hasDockerTag := false

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		trimmed := strings.TrimSpace(line)

		if strings.HasPrefix(strings.ToLower(trimmed), "host ") {
			if currentHost != "" && currentHost != "*" && hasDockerTag {
				dockerHosts = append(dockerHosts, currentHost)
			}
			fields := strings.Fields(trimmed)
			if len(fields) > 1 {
				currentHost = fields[1]
			} else {
				currentHost = ""
			}
			hasDockerTag = false
		} else if strings.Contains(line, "#") && strings.Contains(line, "@docker") {
			hasDockerTag = true
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	if currentHost != "" && currentHost != "*" && hasDockerTag {
		dockerHosts = append(dockerHosts, currentHost)
	}

	var entries []Entry
	for _, host := range dockerHosts {
		entries = append(entries, Entry{
			DisplayName: fmt.Sprintf("󰡨 docker@%s", host),
			WindowTitle: fmt.Sprintf("docker@%s", host),
			ExecCmd:     fmt.Sprintf("DOCKER_HOST=\"ssh://%s\" lazydocker", host),
			PreviewCmd:  fmt.Sprintf("%s preview docker --host %s", m.SelfBin, host),
		})
	}
	return entries, nil
}

type containerInfo struct {
	Name   string
	Image  string
	Status string
	Ports  string
	CPU    string
	Mem    string
}

func RunPreviewDocker(host string) error {
	lipgloss.SetColorProfile(termenv.TrueColor)

	var (
		containerName = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("205"))
		treeStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("240"))
		valStyle      = lipgloss.NewStyle().Foreground(lipgloss.Color("252"))
		mutedStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("245"))
		errorStyle    = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("196"))
	)

	sshOpts := []string{
		"-o", "BatchMode=yes",
		"-o", "ConnectTimeout=2",
		"-o", "StrictHostKeyChecking=accept-new",
	}

	psFmt := "{{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}"
	statsFmt := "{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

	remoteCmd := fmt.Sprintf("docker ps --format %q 2>/dev/null; echo '---DELIM---'; docker stats --no-stream --format %q 2>/dev/null", psFmt, statsFmt)

	args := append(sshOpts, host, remoteCmd)
	cmd := exec.Command("ssh", args...)
	out, err := cmd.Output()

	if err != nil || len(strings.TrimSpace(string(out))) == 0 {
		fmt.Println(errorStyle.Render("✖ Docker unreachable or daemon not running on host"))
		return nil
	}

	parts := strings.Split(string(out), "---DELIM---")
	if len(parts) == 0 || strings.TrimSpace(parts[0]) == "" {
		fmt.Println(errorStyle.Render("No active containers found"))
		return nil
	}

	containers := make(map[string]*containerInfo)
	var order []string

	for line := range strings.SplitSeq(strings.TrimSpace(parts[0]), "\n") {
		fields := strings.Split(line, "\t")
		if len(fields) >= 4 {
			name := fields[0]
			status := fields[1]
			ports := fields[2]
			image := fields[3]

			if ports != "" {
				ports = cleanPorts(ports)
			}

			containers[name] = &containerInfo{
				Name:   name,
				Image:  image,
				Status: status,
				Ports:  ports,
				CPU:    "-",
				Mem:    "-",
			}
			order = append(order, name)
		}
	}

	if len(parts) > 1 {
		for line := range strings.SplitSeq(strings.TrimSpace(parts[1]), "\n") {
			fields := strings.Split(line, "\t")
			if len(fields) >= 3 {
				name := fields[0]
				if c, exists := containers[name]; exists {
					c.CPU = fields[1]
					memParts := strings.Split(fields[2], " / ")
					if len(memParts) > 0 {
						c.Mem = memParts[0]
					}
				}
			}
		}
	}

	fmt.Println()

	for i, name := range order {
		c := containers[name]
		hasPorts := c.Ports != ""

		fmt.Printf(
			"📦 %s %s\n",
			containerName.Render(c.Name),
			mutedStyle.Render("("+c.Image+")"),
		)

		fmt.Printf("%s Uptime: %s\n", treeStyle.Render("├──"), valStyle.Render(c.Status))

		resBranch := "├──"
		if !hasPorts {
			resBranch = "└──"
		}
		resStr := fmt.Sprintf("CPU: %s | RAM: %s", c.CPU, c.Mem)
		fmt.Printf("%s Resources: %s\n", treeStyle.Render(resBranch), valStyle.Render(resStr))

		if hasPorts {
			fmt.Printf("%s Ports: %s\n", treeStyle.Render("└──"), valStyle.Render(c.Ports))
		}

		if i < len(order)-1 {
			fmt.Println()
		}
	}

	return nil
}

func cleanPorts(raw string) string {
	var cleaned []string
	for p := range strings.SplitSeq(raw, ", ") {
		if !strings.Contains(p, "->") {
			continue
		}

		if strings.HasPrefix(p, ":::") {
			continue
		}

		p = strings.TrimPrefix(p, "0.0.0.0:")
		p = strings.TrimSuffix(p, "/tcp")
		p = strings.TrimSpace(p)

		if p != "" {
			cleaned = append(cleaned, p)
		}
	}
	return strings.Join(cleaned, ", ")
}
