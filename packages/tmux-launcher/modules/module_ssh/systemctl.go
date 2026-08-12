package module_ssh

import (
	"fmt"
	"os/exec"
	"strings"

	"github.com/cethien/tmux-launcher/types"
	"github.com/charmbracelet/lipgloss"
	"github.com/muesli/termenv"
)

func getSystemctlEntries(selfBin string, hosts []ConfigHost) []types.Entry {
	var entries []types.Entry
	for _, h := range hosts {
		name := fmt.Sprintf("systemctl@%s", h.Name)
		entries = append(entries, types.Entry{
			Icon:        "󰒓",
			Name:        name,
			WindowTitle: name,
			ExecCmd:     fmt.Sprintf("systemctl-tui --host %s", h.Name),
			PreviewCmd:  fmt.Sprintf("%s preview --module ssh --target ssh:%s", selfBin, h.Name),
		})
	}
	return entries
}

func RunPreviewSystemctl(host string) error {
	lipgloss.SetColorProfile(termenv.TrueColor)

	var (
		headerStyle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("205"))
		okStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("82"))
		warnStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("214"))
		errorStyle  = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("196"))
	)

	sshOpts := []string{
		"-T",
		"-q",
		"-o", "BatchMode=yes",
		"-o", "ConnectTimeout=2",
		"-o", "StrictHostKeyChecking=accept-new",
	}

	// Hol dir die gescheiterten systemd Services vom Remote-Host
	remoteCmd := "systemctl list-units --state=failed --no-legend 2>/dev/null"
	args := append(sshOpts, host, remoteCmd)

	cmd := exec.Command("ssh", args...)
	out, err := cmd.Output()
	if err != nil {
		fmt.Println(errorStyle.Render("✖ Could not reach host or systemd check failed"))
		return nil
	}

	raw := strings.TrimSpace(string(out))

	fmt.Println()
	fmt.Println(headerStyle.Render("⚙  Systemctl Status: " + host))
	fmt.Println()

	if raw == "" {
		fmt.Println(" " + okStyle.Render("✔ All systemd units are running healthy!"))
	} else {
		fmt.Println(" " + warnStyle.Render("✖ Failed Units:"))
		for _, line := range strings.Split(raw, "\n") {
			fields := strings.Fields(line)
			if len(fields) > 0 {
				fmt.Printf("   • %s\n", errorStyle.Render(fields[0]))
			}
		}
	}

	return nil
}
