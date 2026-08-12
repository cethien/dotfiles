package main

import (
	"github.com/cethien/tmux-launcher/types"
)

type Registry struct {
	modules map[string]types.Module
}

func NewRegistry() *Registry {
	return &Registry{
		modules: make(map[string]types.Module),
	}
}

func (r *Registry) Register(m types.Module) {
	r.modules[m.Name()] = m
}

func (r *Registry) GetModule(name string) types.Module {
	return r.modules[name]
}

func (r *Registry) CollectAllEntries() ([]types.Entry, error) {
	var allEntries []types.Entry
	for _, mod := range r.modules {
		entries, err := mod.GetEntries()
		if err != nil {
			continue
		}
		allEntries = append(allEntries, entries...)
	}
	return allEntries, nil
}
