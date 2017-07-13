package main

import (
	"cases/core"
	"fmt"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"sync"
	"time"
)

const (
	// DefDBHost defines a default MongoDB server host: local machine
	DefDBHost string = "127.0.0.1"
	// DefDBPort defines a default MongoDB server port
	DefDBPort string = "27017"
	// DefDBUser defines the default MongoDB username to be used for connection
	DefDBUser string = "casesusr"
	// DefDBPwd defines a default MongoDB user password
	DefDBPwd string = "Rx4awa#$Q"
	// DefDBName defines a default MongoDB database name
	DefDBName string = "cases"
	// DefDBTimeout defines a default timeout (in seconds) in which connection to MongoDB server must be established
	DefDBTimeout int = 5
)

// For operations on DB, simple mutex will do...
var dblock sync.Mutex

// MongoIDToString converts BSON Object ID to string hex representation.
func MongoIDToString(id bson.ObjectId) string { return id.Hex() }

// MongoStringToID converts Mongo ID from hex string representation to BSON Object ID.
func MongoStringToID(id string) bson.ObjectId {

	if id != "" {
		return (bson.ObjectIdHex(id))
	}
	return bson.ObjectId(id)
}

// NewMongoID creates new ObjectId
func NewMongoID() bson.ObjectId { return bson.NewObjectId() }

// MongoDBConnection represents the needed information about current connection to MongoDB database server.
type MongoDBConnection struct {

	// name of the MongoDB database
	Name string

	//
	Session *mgo.Session
}

// NewMongoDBConnection creates a new Mongo DB connection
func NewMongoDBConnection() *MongoDBConnection {
	return &MongoDBConnection{
		Name:    "",
		Session: nil,
	}
}

//
func createMongoConnectString(cfg *Cfg) string {
	return fmt.Sprintf("mongodb://%s:%s@%s:%s/%s", cfg.DB.User, cfg.DB.Passwd, cfg.DB.Host, cfg.DB.Port, cfg.DB.Name)
}

// Connect connects to MongoDB database server with given information and timeout (when connection cannot be established).
func (cn *MongoDBConnection) Connect(dburl string, timeout int) error {

	var sess *mgo.Session
	var err error

	if sess, err = mgo.DialWithTimeout(dburl, time.Duration(timeout)*time.Second); err != nil {
		return err
	}
	cn.Session = sess

	return cn.EnsureIndexes()
}

// ConnectDB connects to MongoDB database server with given information and timeout (when connection cannot be established).
func ConnectDB(cfg *Cfg) (*MongoDBConnection, error) {

	url := fmt.Sprintf("mongodb://%s:%s@%s:%s/%s", cfg.DB.User, cfg.DB.Passwd, cfg.DB.Host, cfg.DB.Port, cfg.DB.Name)
	var sess *mgo.Session
	var err error

	cn := &MongoDBConnection{Session: nil, Name: ""}
	if sess, err = mgo.DialWithTimeout(url, time.Duration(cfg.DB.Timeout)*time.Second); err != nil {
		return nil, err
	}
	cn.Session = sess
	cn.Name = cfg.DB.Name

	err = cn.EnsureIndexes()
	return cn, err
}

// EnsureIndexes ensures that MongoDB indexes are created, when app is started.
func (cn *MongoDBConnection) EnsureIndexes() error {

	// wildcard text index is common to all collection
	wcix := mgo.Index{Key: []string{"$text:$**"}, Background: true, Sparse: true}

	var err error
	// the cases collection indexes
	coll := cn.Session.DB(cn.Name).C("cases")
	cix1 := mgo.Index{Key: []string{"priority"}, Background: true, Sparse: true}
	cix2 := mgo.Index{Key: []string{"auto"}, Background: true, Sparse: true}
	cix3 := mgo.Index{Key: []string{"reqid"}, Background: true, Sparse: true}
	cix4 := mgo.Index{Key: []string{"caseid"}, Unique: true, Background: true, Sparse: true}
	err = coll.EnsureIndex(cix1)
	err = coll.EnsureIndex(cix2)
	err = coll.EnsureIndex(cix3)
	err = coll.EnsureIndex(cix4)
	err = coll.EnsureIndex(wcix)

	// the requirements collection indexes
	coll = cn.Session.DB(cn.Name).C("requirements")
	rix3 := mgo.Index{Key: []string{"globalid"}, Unique: true, Background: true, Sparse: true}
	rix1 := mgo.Index{Key: []string{"priority"}, Background: true, Sparse: true}
	rix2 := mgo.Index{Key: []string{"status"}, Background: true, Sparse: true}
	err = coll.EnsureIndex(rix1)
	err = coll.EnsureIndex(rix2)
	err = coll.EnsureIndex(rix3)
	err = coll.EnsureIndex(wcix)

	// the projets collection indexes
	coll = cn.Session.DB(cn.Name).C("projects")
	pix1 := mgo.Index{Key: []string{"globalid"}, Unique: true, Background: true, Sparse: true}
	err = coll.EnsureIndex(pix1)
	err = coll.EnsureIndex(wcix)

	return err
}

// CloseDB safely closes the session to MongoDB database server and updates its internals.
func CloseDB(cn *MongoDBConnection) {
	if cn.Session != nil {
		cn.Session.Close()
		cn.Session = nil
		cn.Name = ""
	}
}

// Close safely closes the session to MongoDB database server and updates its internals.
func (cn *MongoDBConnection) Close() {
	if cn.Session != nil {
		cn.Session.Close()
		cn.Session = nil
		cn.Name = ""
	}
}

// Timestamp represents a timestamp for different DB records (for created & modified fields).
type Timestamp string

// NewTimestamp creates a properly formatted new instance of Timestamp.
func NewTimestamp() Timestamp { return Timestamp(time.Now().Format(time.RFC822)) }

// String returns the string representation of the timestamp.
func (t Timestamp) String() string { return string(t) }

// Case is a MongoDb wrapper for core Case type.
type Case struct {

	// ID is a MongoDB object ID
	ID bson.ObjectId `bson:"_id"`

	// Case is a wrapped core Case type instance
	core.Case `bson:",inline"`

	// Created & Modified are the usual DB timestamps
	Created, Modified Timestamp
}

// NewCase creates a new instance of Case from minimum of mandatory information.
func NewCase(id, name string) *Case {
	t := NewTimestamp()
	return &Case{
		ID:       bson.NewObjectId(),
		Case:     *core.NewCase(id, name),
		Created:  t,
		Modified: t,
	}
}

// GetCases returns all items from the "cases" collection in the DB.
func (cn *MongoDBConnection) GetCases(srch string) ([]*Case, error) {

	dblock.Lock()
	defer dblock.Unlock()

	var cases []*Case
	var err error
	coll := cn.Session.DB(cn.Name).C("cases")
	if srch == "" {
		err = coll.Find(bson.D{}).All(&cases)
	} else {
		err = coll.Find(bson.M{"$text": bson.M{"$search": srch}}).All(&cases)
	}
	return cases, err
}

// GetCase returns a particular item (with given ID) from the "cases" collection.
func (cn *MongoDBConnection) GetCase(id string) (*Case, error) {

	dblock.Lock()
	defer dblock.Unlock()

	cs := NewCase("", "")
	coll := cn.Session.DB(cn.Name).C("cases")
	if err := coll.Find(bson.M{"_id": MongoStringToID(id)}).One(cs); err != nil {
		return nil, err
	}
	return cs, nil
}

// InsertCase adds a new test case into DB.
func (cn *MongoDBConnection) InsertCase(c *Case) error {

	dblock.Lock()
	defer dblock.Unlock()

	t := NewTimestamp()
	c.Created = t
	c.Modified = t

	coll := cn.Session.DB(cn.Name).C("cases")
	if err := coll.Insert(c); err != nil {
		return fmt.Errorf("Error inserting a test case: %q\n", err.Error())
	}
	return nil
}

// DeleteCase removes a test case from DB.
func (cn *MongoDBConnection) DeleteCase(id string) error {

	dblock.Lock()
	defer dblock.Unlock()

	coll := cn.Session.DB(cn.Name).C("cases")
	if err := coll.RemoveId(MongoStringToID(id)); err != nil {
		return fmt.Errorf("Error deleting a test case '%s': '%s'\n", id, err.Error())
	}
	return nil
}

// ModifyCase updates the existing case in the DB.
func (cn *MongoDBConnection) ModifyCase(c *Case) error {

	dblock.Lock()
	defer dblock.Unlock()

	c.Modified = NewTimestamp()
	coll := cn.Session.DB(cn.Name).C("cases")
	if err := coll.UpdateId(c.ID, c); err != nil {
		return fmt.Errorf("Error updating a test case %v: '%s'\n", c.ID, err.Error())
	}
	return nil
}

// Requirement is a MongoDb wrapper for core Requirement type.
type Requirement struct {

	// ID is a MongoDB object ID
	ID bson.ObjectId `bson:"_id"`

	// Requirement is a wrapped core Requirement type instance
	core.Requirement `bson:",inline"`

	// Created & Modified are the usual DB timestamps
	Created, Modified Timestamp
}

// NewRequirement creates a new instance of Requirement from minimum of mandatory information.
func NewRequirement(id, name string) *Requirement {

	t := NewTimestamp()
	r := core.NewRequirement()
	r.GlobalID = id
	r.Name = name
	return &Requirement{
		ID:          bson.NewObjectId(),
		Requirement: *r,
		Created:     t,
		Modified:    t,
	}
}

// GetRequirements returns all items from the "requirements" collection in the DB.
func (cn *MongoDBConnection) GetRequirements(srch string) ([]*Requirement, error) {

	dblock.Lock()
	defer dblock.Unlock()

	var reqs []*Requirement
	var err error
	coll := cn.Session.DB(cn.Name).C("requirements")
	if srch == "" {
		err = coll.Find(bson.D{}).All(&reqs)
	} else {
		err = coll.Find(bson.M{"$text": bson.M{"$search": srch}}).All(&reqs)
	}
	return reqs, err
}

// GetRequirement returns a particular item (with given ID) from the "requirements" collection.
func (cn *MongoDBConnection) GetRequirement(id string) (*Requirement, error) {

	dblock.Lock()
	defer dblock.Unlock()

	r := NewRequirement("", "")
	coll := cn.Session.DB(cn.Name).C("requirements")
	if err := coll.Find(bson.M{"_id": MongoStringToID(id)}).One(r); err != nil {
		return nil, err
	}
	return r, nil
}

// InsertRequirement adds a new requirement into DB.
func (cn *MongoDBConnection) InsertRequirement(r *Requirement) error {

	dblock.Lock()
	defer dblock.Unlock()

	t := NewTimestamp()
	r.Created = t
	r.Modified = t

	coll := cn.Session.DB(cn.Name).C("requirements")
	if err := coll.Insert(r); err != nil {
		return fmt.Errorf("Error inserting a requirement: %q\n", err.Error())
	}
	return nil
}

// DeleteRequirement removes a requirement from DB.
// All test cases that were bound to the given requirement are unconditionally assigned new value "Unknown".
func (cn *MongoDBConnection) DeleteRequirement(id string) error {

	dblock.Lock()
	defer dblock.Unlock()

	var err error
	coll := cn.Session.DB(cn.Name).C("requirements")

	// first, we need to get the requirement to be able to clean cases after the requirement is removed.
	req := NewRequirement("", "")
	if err := coll.Find(bson.M{"_id": MongoStringToID(id)}).One(req); err != nil {
		return err
	}
	name := fmt.Sprintf("%s %s", req.GlobalID, req.Name)

	// now we remove the requirement from the DB...
	if err = coll.RemoveId(MongoStringToID(id)); err != nil {
		return fmt.Errorf("Error deleting a requirement '%s': '%s'\n", id, err.Error())
	}

	// and now we clean the cases collection
	coll = cn.Session.DB(cn.Name).C("cases")
	t := NewTimestamp()
	_, err = coll.UpdateAll(bson.M{"reqid": name}, bson.M{"$set": bson.M{"reqid": "Unknown", "modified": t}})
	return err
}

// ModifyRequirement updates the existing case in the DB.
func (cn *MongoDBConnection) ModifyRequirement(r *Requirement) error {

	dblock.Lock()
	defer dblock.Unlock()

	r.Modified = NewTimestamp() // update the 'modified' timestamp
	coll := cn.Session.DB(cn.Name).C("requirements")
	if err := coll.UpdateId(r.ID, r); err != nil {
		return fmt.Errorf("Error updating a requirement %v: '%s'\n", r.ID, err.Error())
	}
	return nil
}

// Project is a MongoDb wrapper for core Project type.
type Project struct {

	// ID is a MongoDB object ID
	ID bson.ObjectId `bson:"_id"`

	// Requirement is a wrapped core Requirement type instance
	core.Project `bson:",inline"`

	// Created & Modified are the usual DB timestamps
	Created, Modified Timestamp
}

// NewProject creates a new instance of Project from minimum of mandatory information.
func NewProject(id, name string) *Project {
	t := NewTimestamp()
	return &Project{
		ID:       bson.NewObjectId(),
		Project:  *core.NewProject(id, name),
		Created:  t,
		Modified: t,
	}
}

// GetProjects returns all items from the "projects" collection in the DB.
func (cn *MongoDBConnection) GetProjects(srch string) ([]*Project, error) {

	dblock.Lock()
	defer dblock.Unlock()

	var p []*Project
	var err error
	coll := cn.Session.DB(cn.Name).C("projects")
	if srch == "" {
		err = coll.Find(bson.D{}).All(&p)
	} else {
		err = coll.Find(bson.M{"$text": bson.M{"$search": srch}}).All(&p)
	}
	return p, err
}

// GetProject returns a particular item (with given ID) from the "projects" collection.
func (cn *MongoDBConnection) GetProject(id string) (*Project, error) {

	dblock.Lock()
	defer dblock.Unlock()

	p := NewProject("", "")
	coll := cn.Session.DB(cn.Name).C("projects")
	if err := coll.Find(bson.M{"_id": MongoStringToID(id)}).One(p); err != nil {
		return nil, err
	}
	return p, nil
}

// InsertProject adds a new project into DB.
func (cn *MongoDBConnection) InsertProject(p *Project) error {

	dblock.Lock()
	defer dblock.Unlock()

	t := NewTimestamp()
	p.Created = t
	p.Modified = t

	coll := cn.Session.DB(cn.Name).C("projects")
	if err := coll.Insert(p); err != nil {
		return fmt.Errorf("Error inserting a project: %s", err.Error())
	}
	return nil
}

// DeleteProject removes a project from DB.
func (cn *MongoDBConnection) DeleteProject(id string) error {

	dblock.Lock()
	defer dblock.Unlock()

	var err error
	coll := cn.Session.DB(cn.Name).C("projects")

	// first, we need to get the project to be able to clean requiremenst after the project is removed.
	p := NewProject("", "")
	if err := coll.Find(bson.M{"_id": MongoStringToID(id)}).One(p); err != nil {
		return err
	}
	name := fmt.Sprintf("%s", p.String)

	// now we remove the project from the DB...
	if err = coll.RemoveId(MongoStringToID(id)); err != nil {
		return fmt.Errorf("Error deleting a project '%s': '%s'\n", id, err.Error())
	}

	// and now we clean the cases collection
	coll = cn.Session.DB(cn.Name).C("requirements")
	t := NewTimestamp()
	_, err = coll.UpdateAll(bson.M{"project": name}, bson.M{"$set": bson.M{"project": "Unknown", "modified": t}})
	return err
}

// ModifyProject updates the existing project in the DB.
func (cn *MongoDBConnection) ModifyProject(p *Project) error {

	dblock.Lock()
	defer dblock.Unlock()

	p.Modified = NewTimestamp() // update the 'modified' timestamp
	coll := cn.Session.DB(cn.Name).C("projects")
	if err := coll.UpdateId(p.ID, p); err != nil {
		return fmt.Errorf("Error updating a project %v: '%s'\n", p.ID, err.Error())
	}
	return nil
}
