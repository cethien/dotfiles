package module_toml

import (
	"encoding/base64"
	"fmt"
	"os"
	"strings"

	"github.com/cethien/tmux-launcher/types"
	"github.com/charmbracelet/glamour"
	"github.com/charmbracelet/lipgloss"
	"github.com/muesli/termenv"
	"github.com/pelletier/go-toml/v2"
)

type TomlConfig struct {
	Entries []struct {
		Icon        string `toml:"icon"`
		Name        string `toml:"name"`
		Hold        bool   `toml:"hold"`
		Exec        string `toml:"exec"`
		Preview     string `toml:"preview"`
		PreviewText string `toml:"preview_text"`
	} `toml:"entries"`
}

type Module struct {
	ConfigPath   string
	SelfBin      string
	SessionEmoji string
}

func New(configPath string, selfBin string) *Module {
	return &Module{
		ConfigPath:   configPath,
		SelfBin:      selfBin,
		SessionEmoji: GetRandomKaomoji(), // Wird direkt intern gewürfelt!
	}
}

func (m *Module) Name() string {
	return "toml"
}

func (m *Module) GetEntries() ([]types.Entry, error) {
	data, err := os.ReadFile(m.ConfigPath)
	if err != nil {
		if os.IsNotExist(err) {
			return nil, nil
		}
		return nil, err
	}

	var cfg TomlConfig
	if err := toml.Unmarshal(data, &cfg); err != nil {
		return nil, err
	}

	encodedEmoji := base64.StdEncoding.EncodeToString([]byte(m.SessionEmoji))

	var entries []types.Entry
	for _, e := range cfg.Entries {
		if e.Name == "" || e.Exec == "" {
			continue
		}

		execCmd := e.Exec
		if e.Hold {
			execCmd = fmt.Sprintf("%s; echo -e '\\n[Finished] Press Ctrl+C to close...'; trap 'exit 0' INT; sleep infinity", e.Exec)
		}

		var previewCmd string
		if e.PreviewText != "" {
			encoded := base64.StdEncoding.EncodeToString([]byte(e.PreviewText))
			previewCmd = fmt.Sprintf("%s preview --module toml --target text:%s", m.SelfBin, encoded)
		} else if e.Preview != "" {
			previewCmd = e.Preview
		} else {
			previewCmd = fmt.Sprintf("%s preview --module toml --target empty:%s", m.SelfBin, encodedEmoji)
		}

		entries = append(entries, types.Entry{
			Icon:        e.Icon,
			Name:        e.Name,
			WindowTitle: e.Name,
			ExecCmd:     execCmd,
			PreviewCmd:  previewCmd,
		})
	}
	return entries, nil
}

func (m *Module) RenderPreview(target string) error {
	kind, payload, found := strings.Cut(target, ":")
	if !found {
		payload = target
		kind = "empty"
	}

	switch kind {
	case "text":
		return RunPreviewText(payload)
	case "empty":
		return RunPreviewEmpty(payload)
	default:
		return fmt.Errorf("unknown toml preview target kind: %s", kind)
	}
}

func RunPreviewText(b64Text string) error {
	decoded, err := base64.StdEncoding.DecodeString(b64Text)
	if err != nil {
		return err
	}

	out, err := glamour.Render(string(decoded), "tokyo-night")
	if err != nil {
		fmt.Println(string(decoded))
		return nil
	}

	fmt.Print(out)
	return nil
}

func RunPreviewEmpty(b64Kaomoji string) error {
	lipgloss.SetColorProfile(termenv.TrueColor)

	kaomoji, err := base64.StdEncoding.DecodeString(b64Kaomoji)
	if err != nil || len(kaomoji) == 0 {
		kaomoji = []byte("▼・ᴥ・▼")
	}

	animalStyle := lipgloss.NewStyle().Foreground(lipgloss.Color("220")).Bold(true)
	quoteStyle := lipgloss.NewStyle().Foreground(lipgloss.Color("244")).Italic(true)

	fmt.Println()
	fmt.Printf(" %s\n", animalStyle.Render(string(kaomoji)))
	fmt.Printf(" %s\n", quoteStyle.Render(`"wow. such preview. much empty. very command."`))

	return nil
}
