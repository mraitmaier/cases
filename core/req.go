package core

//

// ReqStatus represents valid values for requirement status.
type ReqStatus int

const (
    // StatusUnknown represents the unknown requirement status
	StatusUnknown = iota
    // StatusNew represents the new requirement status
	StatusNew
    // StatusAcknowledged represents the acknowledged requirement status
	StatusAcknowledged
    // StatusPending represents the pending requirement status
	StatusPending
    // StatusApproved represents the approved requirement status
	StatusApproved
    // StatusRejected represents the rejected requirement status
	StatusRejected
    // StatusObsolete represents the obsolete requirement status
	StatusObsolete
)

// String returns a string representation of the requirement status value.
func (r ReqStatus) String() string {

	switch r {
	case StatusUnknown:
		return "Unknown"
	case StatusNew:
		return "New"
	case StatusAcknowledged:
		return "Acknowledged"
	case StatusPending:
		return "Pending"
	case StatusApproved:
		return "Approved"
	case StatusRejected:
		return "Rejected"
	case StatusObsolete:
		return "Obsolete"
	default:
		return "Error status"
	}
}

// ReqStatusFromString coverts a string value for status to custom enum value.
func ReqStatusFromString(val string) ReqStatus {

	switch val {
	case "New", "new", "NEW":
		return StatusNew
	case "Acknowledged", "ACKNOWLEDGED", "acknowledged":
		return StatusAcknowledged
	case "Pending", "pending", "PENDING":
		return StatusPending
	case "Approved", "approved", "APPROVED":
		return StatusApproved
	case "Rejected", "rejected", "REJECTED":
		return StatusRejected
	case "Obsolete", "obsolete", "OBSOLETE":
		return StatusObsolete
	}
	return StatusUnknown
}

// Requirement is a representation of the feature requirement.
type Requirement struct {

	// Short name of the requirement
	Short string

	// Name of the requirement
	Name string

	// Description is longer text that describes a requirement fully.
	Description string

	// ReqStatus is the current status of the requirement.
	Status ReqStatus

	// Priority of the requirement: low, normal, high
	Priority
}

// CreateRequirement returns a new instance of Requirement type from the known data.
func CreateRequirement(short, name, desc string, prio Priority, status ReqStatus) *Requirement {
	return &Requirement{
		Short:       short,
		Name:        name,
		Description: desc,
		Priority:    prio,
		Status:      status,
	}
}

// NewRequirement returns a new empty instance of Requirement type.
func NewRequirement() *Requirement {
	return &Requirement{
		Short:       "",
		Name:        "",
		Description: "",
		Priority:    NormalPriority,
		Status:      StatusUnknown,
	}
}
