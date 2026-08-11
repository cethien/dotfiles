package main

import "fmt"

type Entry struct {
	DisplayName string
	WindowTitle string
	ExecCmd     string
	PreviewCmd  string
}

func (e Entry) ToFzfLine() string {
	return fmt.Sprintf("%s\t%s\t%s\t%s", e.DisplayName, e.WindowTitle, e.ExecCmd, e.PreviewCmd)
}

type Module interface {
	Name() string
	GetEntries() ([]Entry, error)
}
