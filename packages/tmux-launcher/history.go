package main

import (
	"encoding/json"
	"os"
	"path/filepath"
	"time"
)

type HistoryEntry struct {
	Count    int       `json:"count"`
	LastUsed time.Time `json:"last_used"`
}

type History map[string]*HistoryEntry

func getHistoryPath() string {
	stateDir := os.Getenv("XDG_STATE_HOME")
	if stateDir == "" {
		home, _ := os.UserHomeDir()
		stateDir = filepath.Join(home, ".local", "state")
	}
	return filepath.Join(stateDir, "tmux-launcher", "history.json")
}

func LoadHistory() History {
	h := make(History)
	data, err := os.ReadFile(getHistoryPath())
	if err != nil {
		return h
	}
	_ = json.Unmarshal(data, &h)
	return h
}

func (h History) Save() {
	path := getHistoryPath()
	_ = os.MkdirAll(filepath.Dir(path), 0o755)
	data, _ := json.MarshalIndent(h, "", "  ")
	_ = os.WriteFile(path, data, 0o644)
}

func (h History) RecordUse(name string) {
	if entry, exists := h[name]; exists {
		entry.Count++
		entry.LastUsed = time.Now()
	} else {
		h[name] = &HistoryEntry{Count: 1, LastUsed: time.Now()}
	}
	h.Save()
}

func (h History) GetScore(name string) float64 {
	entry, exists := h[name]
	if !exists {
		return 0
	}
	hoursAgo := time.Since(entry.LastUsed).Hours()

	recencyWeight := 1.0
	if hoursAgo < 1 {
		recencyWeight = 4.0
	} else if hoursAgo < 24 {
		recencyWeight = 2.0
	} else if hoursAgo < 168 { // 1 Woche
		recencyWeight = 1.2
	}

	return float64(entry.Count) * recencyWeight
}
