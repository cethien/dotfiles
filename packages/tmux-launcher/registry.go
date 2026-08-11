package main

type Registry struct {
	modules []Module
}

func NewRegistry() *Registry {
	return &Registry{
		modules: make([]Module, 0),
	}
}

func (r *Registry) Register(m Module) {
	r.modules = append(r.modules, m)
}

func (r *Registry) CollectAllEntries() ([]Entry, error) {
	var allEntries []Entry
	for _, mod := range r.modules {
		entries, err := mod.GetEntries()
		if err != nil {
			// Fehler ignorieren oder loggen, damit ein kaputtes Modul nicht alles blockiert
			continue
		}
		allEntries = append(allEntries, entries...)
	}
	return allEntries, nil
}
