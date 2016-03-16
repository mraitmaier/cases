package core

//

import (
	"fmt"
)

// Priority is an enum representing the test case's priority
type Priority int

const (
	_ Priority = iota
	// LowPriority represents a low regression priority test case.
	LowPriority
	// NormalPriority represents a normal regression priority test case.
	NormalPriority
	// HighPriority represents a high regression priority test case.
	HighPriority
)

// String representation of the Priority type.
func (p Priority) String() string {

	switch p {
	case LowPriority:
		return "Low"
	case NormalPriority:
		return "Normal"
	case HighPriority:
		return "High"
	default:
		return "Error priority"
	}
}

// PriorityFromString returns a priority value parsed from string.
func PriorityFromString(val string) Priority {

	switch val {
	case "Low", "low", "LOW", "l", "L":
		return LowPriority
	case "Normal", "normal", "NORMAL", "N", "n":
		return NormalPriority
	case "High", "high", "HIGH", "h", "H":
		return HighPriority
	}
	return NormalPriority
}

// Case is type that abstracts the test case.
// In case of Desc, Expect & Notes members, we allow basic HTML formatting.
type Case struct {

	// ID represents a test case's unique identification.
	CaseID string

	// Name represents the name of the test case: mandatory but not necessarily unique.
	Name string

	// Desc holds the text that describes the test case. Can be formatted as a basic HTML.
	Desc string

	// Expect holds the text describing the expected results. Can be formatted as a basic HTML.
	Expect string

	// Prio defines the regression priority of the test case.
	Priority

	// Auto is indicating whether the test case has been automated yet or not.
	Auto bool

	// Notes holds the optional additional text that might be important for executing the test case.
	Notes string

	// ReqID holds the ID of the associated requirement.
	ReqID string
}

// NewCase creates a new instance of Case with minimum of mandatory data needed. Priority is set to normal.
func NewCase(id, name string) *Case {

	return &Case{
		CaseID:   id,
		Name:     name,
		Priority: NormalPriority,
		Auto:     false,
	}
}

// Formatted returns the case information as properly formatted HTML text.
func (c *Case) Formatted(cls string) string {
	s := fmt.Sprintf("<div class=%q>\n", cls)
	s += fmt.Sprintf("ID: %s<br />\n", c.CaseID)
	s += fmt.Sprintf("Name: %s<br />\n", c.Name)
	s += fmt.Sprintf("</div>\n")
	return s
}
