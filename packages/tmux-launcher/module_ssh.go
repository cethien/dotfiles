package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"

	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/lipgloss/table"
	"github.com/muesli/termenv"
)

type SshModule struct {
	SelfBin string
}

func NewSshModule(selfBin string) *SshModule {
	return &SshModule{SelfBin: selfBin}
}

func (m *SshModule) Name() string {
	return "ssh"
}

func (m *SshModule) GetEntries() ([]Entry, error) {
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

	var hosts []string
	hostRegex := regexp.MustCompile(`(?i)^\s*Host\s+(.+)$`)
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		matches := hostRegex.FindStringSubmatch(line)
		if len(matches) > 1 {
			for h := range strings.FieldsSeq(matches[1]) {
				if h != "*" && !strings.HasPrefix(h, "!") {
					hosts = append(hosts, h)
				}
			}
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	var entries []Entry
	for _, host := range hosts {
		entries = append(entries, Entry{
			DisplayName: fmt.Sprintf("󰣀 ssh@%s", host),
			WindowTitle: fmt.Sprintf("ssh@%s", host),
			ExecCmd:     fmt.Sprintf("ssh -t %s 'tmux attach || tmux new-session || exec $SHELL'", host),
			PreviewCmd:  fmt.Sprintf("%s preview ssh --host %s", m.SelfBin, host),
		})
	}
	return entries, nil
}

func parseOSRelease(raw string) string {
	for line := range strings.SplitSeq(raw, "\n") {
		if strings.HasPrefix(line, "PRETTY_NAME=") {
			val := strings.TrimPrefix(line, "PRETTY_NAME=")
			return strings.Trim(val, `"`)
		}
	}
	return "Linux"
}

func parseUptime(raw string) string {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return "N/A"
	}

	fields := strings.Fields(raw)
	if len(fields) > 0 {
		if seconds, err := strconv.ParseFloat(fields[0], 64); err == nil {
			days := int(seconds) / 86400
			hours := (int(seconds) % 86400) / 3600
			mins := (int(seconds) % 3600) / 60

			if days > 0 {
				return fmt.Sprintf("%dd %dh %dm", days, hours, mins)
			}
			return fmt.Sprintf("%dh %dm", hours, mins)
		}
	}

	if strings.Contains(raw, "up ") {
		parts := strings.Split(raw, "up ")
		if len(parts) > 1 {
			upPart := strings.Split(parts[1], ",")[0]
			return strings.TrimSpace(upPart)
		}
	}

	return raw
}

func parseMemInfo(raw string) string {
	var total, avail float64
	for line := range strings.SplitSeq(raw, "\n") {
		fields := strings.Fields(line)
		if len(fields) < 2 {
			continue
		}
		if fields[0] == "MemTotal:" {
			total, _ = strconv.ParseFloat(fields[1], 64)
		} else if fields[0] == "MemAvailable:" {
			avail, _ = strconv.ParseFloat(fields[1], 64)
		}
	}

	if total > 0 && avail > 0 {
		used := total - avail
		return fmt.Sprintf("%.1fGi / %.1fGi (Available: %.1fGi)", used/1048576, total/1048576, avail/1048576)
	}

	return "N/A"
}

func parseCPULoad(raw string) string {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return "N/A"
	}

	lines := strings.Split(raw, "\n")
	fields := strings.Fields(lines[0])

	if len(fields) < 5 || !strings.HasPrefix(fields[0], "cpu") {
		return "N/A"
	}

	user, err1 := strconv.ParseFloat(fields[1], 64)
	nice, err2 := strconv.ParseFloat(fields[2], 64)
	sys, err3 := strconv.ParseFloat(fields[3], 64)
	idle, err4 := strconv.ParseFloat(fields[4], 64)

	if err1 != nil || err2 != nil || err3 != nil || err4 != nil {
		return "N/A"
	}

	total := user + nice + sys + idle
	if total == 0 {
		return "N/A"
	}

	active := user + nice + sys
	usage := (active / total) * 100

	return fmt.Sprintf("%.1f%%", usage)
}

func RunPreviewSsh(host string) error {
	lipgloss.SetColorProfile(termenv.TrueColor)

	var (
		headerStyle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("205"))
		keyStyle    = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("36"))
		valStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("252"))
		errorStyle  = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("196"))
		divider     = lipgloss.NewStyle().Foreground(lipgloss.Color("238")).Render("────────────────────────────────────────")
	)

	// 1. Lokale SSH Config SOFORT rendern
	sshCfgTable := table.New().
		Border(lipgloss.HiddenBorder()).
		StyleFunc(func(row, col int) lipgloss.Style {
			if col == 0 {
				return keyStyle
			}
			return valStyle
		})

	out, _ := exec.Command("ssh", "-G", host).Output()
	if len(out) > 0 {
		keys := map[string]bool{"user": true, "hostname": true, "port": true, "identityfile": true}
		for line := range strings.SplitSeq(string(out), "\n") {
			parts := strings.SplitN(strings.TrimSpace(line), " ", 2)
			if len(parts) == 2 && keys[strings.ToLower(parts[0])] {
				val := parts[1]
				if len(val) > 40 {
					val = "..." + val[len(val)-37:]
				}
				sshCfgTable.Row(parts[0]+":", val)
			}
		}
	}

	fmt.Println(sshCfgTable.Render())
	fmt.Println(divider)

	sshOpts := []string{
		"-o", "BatchMode=yes",
		"-o", "ConnectTimeout=2",
		"-o", "StrictHostKeyChecking=accept-new",
	}

	remoteScript := "cat /etc/os-release 2>/dev/null; echo '---DELIM---'; cat /proc/uptime 2>/dev/null || uptime; echo '---DELIM---'; head -n1 /proc/stat 2>/dev/null; echo '---DELIM---'; cat /proc/meminfo 2>/dev/null || free -b 2>/dev/null; echo '---DELIM---'; df -h -x tmpfs -x devtmpfs -x overlay 2>/dev/null | grep -E '^/dev/'"

	args := append(sshOpts, host, remoteScript)
	cmd := exec.Command("ssh", args...)
	remoteOut, err := cmd.Output()

	// Zeile mit dem Spinner löschen (ANSI Escape Sequence)
	fmt.Print("\r\033[K")

	if err != nil && len(remoteOut) == 0 {
		fmt.Println(errorStyle.Render("✖ Host unreachable or connection timed out"))
		return nil
	}

	// 3. Remote Data Parsea & Rendern
	parts := strings.Split(string(remoteOut), "---DELIM---")

	metricsTable := table.New().
		Border(lipgloss.HiddenBorder()).
		StyleFunc(func(row, col int) lipgloss.Style {
			if col == 0 {
				return keyStyle
			}
			return valStyle
		})

	if len(parts) >= 4 {
		metricsTable.Row("OS:", parseOSRelease(parts[0]))
		metricsTable.Row("Uptime:", parseUptime(parts[1]))
		metricsTable.Row("CPU Load:", parseCPULoad(parts[2]))
		metricsTable.Row("Memory:", parseMemInfo(parts[3]))
	}

	hasDisks := false
	diskTable := table.New().
		Border(lipgloss.RoundedBorder()).
		BorderStyle(lipgloss.NewStyle().Foreground(lipgloss.Color("62"))).
		Headers("DEV", "USAGE", "MOUNT").
		StyleFunc(func(row, col int) lipgloss.Style {
			if row == table.HeaderRow {
				return lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("205")).Padding(0, 1)
			}
			return valStyle.Padding(0, 1)
		})

	if len(parts) >= 5 {
		for line := range strings.SplitSeq(strings.TrimSpace(parts[4]), "\n") {
			fields := strings.Fields(line)
			if len(fields) >= 6 {
				usage := fmt.Sprintf("%s / %s (%s)", fields[2], fields[1], fields[4])
				diskTable.Row(fields[0], usage, fields[5])
				hasDisks = true
			}
		}
	}

	fmt.Println(metricsTable.Render())

	if hasDisks {
		fmt.Println()
		fmt.Println(headerStyle.Render("Disks"))
		fmt.Println(diskTable.Render())
	}

	return nil
}
