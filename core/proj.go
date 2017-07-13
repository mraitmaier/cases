package core

// proj.go

import (
	"fmt"
)

// Project define a single project
type Project struct {

	// Name is a name of the project
	Name string

	// GlobalID is a short (code) name for a project
	GlobalID string

	// Description is a detailed description of the project
	Description string
}

// NewProject creates a new instance of Project, name is given and short name (abbreviation) is needed.
func NewProject(name, id string) *Project { return &Project{name, id, ""} }

// CreateProject creates a new instance of Project, all data must be given.
func CreateProject(name, id, descr string) *Project { return &Project{name, id, descr} }

// String returns a human-readable representation of the Project instance
func (p *Project) String() string {
	return fmt.Sprintf("%s [%s]", p.Name, p.GlobalID)
}

/*
// XML returns an XML-encoded representation of the Project instance
func (p *Project) XML() (string, error) {

	out, err := xml.MarshalIndent(p, "  ", "    ")
	if err != nil {
		return "", err
	}
	return string(out), err
}

// JSON returns a JSON-encoded representation of the Project instance
func (p *Project) JSON() (string, error) {
	b, err := json.Marshal(p)
	if err != nil {
		return "", err
	}
	return string(b[:]), err
}
*/
