package module_ssh

import (
	"bufio"
	"os"
	"path/filepath"
	"strings"
)

type ConfigHost struct {
	Name      string
	HasDocker bool
}

func parseSshConfig() ([]ConfigHost, error) {
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

	var hosts []ConfigHost
	var currentHost string
	hasDockerTag := false

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		trimmed := strings.TrimSpace(line)

		if strings.HasPrefix(strings.ToLower(trimmed), "host ") {
			if currentHost != "" && currentHost != "*" {
				hosts = append(hosts, ConfigHost{Name: currentHost, HasDocker: hasDockerTag})
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

	if currentHost != "" && currentHost != "*" {
		hosts = append(hosts, ConfigHost{Name: currentHost, HasDocker: hasDockerTag})
	}

	return hosts, nil
}
