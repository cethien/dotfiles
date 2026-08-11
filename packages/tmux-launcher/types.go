package main

import "fmt"

type Entry struct {
	Icon        string
	Name        string
	WindowTitle string
	ExecCmd     string
	PreviewCmd  string
}

func (e Entry) DisplayName() string {
	if e.Icon == "" {
		return e.Name
	}
	return fmt.Sprintf("%s  %s", e.Icon, e.Name)
}

func (e Entry) ToFzfLine() string {
	return fmt.Sprintf("%s\t%s\t%s\t%s\t%s", e.DisplayName(), e.WindowTitle, e.ExecCmd, e.PreviewCmd, e.Name)
}

type Module interface {
	Name() string
	GetEntries() ([]Entry, error)
}
