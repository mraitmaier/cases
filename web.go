package main

import (
	"cases/core"
	"encoding/json"
	"fmt"
	"github.com/gorilla/context"
	"github.com/gorilla/mux"
	"html/template"
	"net/http"
	"path/filepath"
	"strings"
)

const (
	// DefWebRoot defines the root path for web-related stuff: templates, static contents...
	DefWebRoot string = "./web/"

	// UserName (Just for testing purposes...) FIXME
//	UserName string = "Administrator"
)

// PageMessage is the structure for displaying messages on web page
type PageMessage struct {

	// Code is internal error code
	Code int `json:"code"`
	// Type denotes the message type: warning, danger, success, info
	Type string `json:"type"`
	// Message is the actual text of the message
	Message string `json:"message"`
	// Status is HTTP Error Code: 200, 404 etc.
	Status int `json:"status"`
}

// Sring is a handy string represenation of the WebMessage instance.
func (m *PageMessage) String() string {
	return fmt.Sprintf("%d (%s): %s", m.Code, m.Type, m.Message)
}

// MarshalJSON marshals the error message into JSON-encoded text.
func (m *PageMessage) MarshalJSON() ([]byte, error) { return json.Marshal(m) }

// UnmarshalJSON unmarshals the JSON-encoded text into error message.
func (m *PageMessage) UnmarshalJSON(j []byte) error { return json.Unmarshal(j, m) }

// The webStart function actually starts the web application.
func webStart(app *appinfo, wwwpath string) (err error) {

	// register handler functions
	registerHandlers(app)

	// check dir for session files and create it if needed
	//    if !checkSessDir("", aa) {
	//        return errors.New("Cannot create session folder; cannot continue.")
	//    }

	// handle static files
	path := filepath.Join(wwwpath, "static")
	http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir(path))))

	//web page templates, with defined additional functions
	funcs := template.FuncMap{
		"add":     func(x, y int) int { return x + y },
		"length":  func(list []string) int { return len(list) },
		"totitle": func(s string) string { return strings.Title(s) },
		"toupper": func(s string) string { return strings.ToUpper(s) },
		"tolower": func(s string) string { return strings.ToLower(s) }}
	t := filepath.Join(wwwpath, "templates", "*.tpl")
	app.templates = template.Must(template.New("").Funcs(funcs).ParseGlob(t))

	// finally, start web server, we're using HTTP
	http.ListenAndServe(":8888", context.ClearHandler(http.DefaultServeMux))
	//http.ListenAndServeTLS(":8888", "./web/mycert1.cer", "./web/mycert1.key",
	//http.ListenAndServeTLS(":8888", "./web/server.pem", "./web/server.key", context.ClearHandler(http.DefaultServeMux))
	Info(app.log, "WebServer up & running")
	return nil
}

func registerHandlers(app *appinfo) {

	r := mux.NewRouter()
	r.Handle("/", indexHandler(app))
	r.Handle("/index", indexHandler(app))
	r.Handle("/license", licHandler(app))
	r.Handle("/case", caseHandler(app))
	r.Handle("/case/{id}/{cmd}", caseHandler(app))
	r.Handle("/requirement", requirementHandler(app))
	r.Handle("/requirement/{id}/{cmd}", requirementHandler(app))

	r.Handle("/search", searchHandler(app))
	r.Handle("/err404", err404Handler(app))
	r.NotFoundHandler = err404Handler(app)
	http.Handle("/", r) // this must be the last line in func...
}

// Aux function that renders the page (template!) with given (template) name.
// Input parameters are:
// - name - name of the template to render
// - web  - ptr to ad-hoc web struct that is used by template to fill in the data on page
// - aa   - pointer to appinfo instance
// - w    - the ResponseWriter instance
// - r    - ptr to the (HTTP) Request instance
func renderPage(name string, web interface{}, aa *appinfo, w http.ResponseWriter, r *http.Request) error {

	var err error
	if err = aa.templates.ExecuteTemplate(w, name, web); err != nil {
		Errorf(aa.log, "Cannot display %q page, redirecting to 404", name)
		http.Redirect(w, r, "/err404", http.StatusFound)
	}
	Infof(aa.log, "Displaying %q page, everything OK", name)
	return err
}

// This is the cases' page handler function.
func caseHandler(app *appinfo) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		var err error

		switch r.Method {

		case "GET":
			if err = caseHTTPGetHandler("", w, r, app); err != nil {
				Errorf(app.log, "Cases HTTP GET %q", err.Error())
			}

		case "POST":

			if err = caseHTTPPostHandler(w, r, app); err != nil {
				Errorf(app.log, "Cases HTTP POST %q", err.Error())
			}
			// unconditionally reroute to main test cases page
			http.Redirect(w, r, "/case", http.StatusSeeOther)

		case "DELETE":
			Infof(app.log, "Case HTTP DELETE request received. Redirecting to main 'cases' page.")
			// unconditionally reroute to main test cases pag, namee
			// Use HTTP 303 (see other) to force GET to redirect as DELETE request is normally followed by another DELETE
			http.Redirect(w, r, "/case", http.StatusSeeOther)

		case "PUT":
			Infof(app.log, "Case HTTP PUT request received. Redirecting to main 'cases' page.")
			// unconditionally reroute to main test cases page
			// Use HTTP 303 (see other) to force GET to redirect as PUT request is normally followed by another PUT
			http.Redirect(w, r, "/case", http.StatusSeeOther)

		default:
			if err := renderPage("index", nil, app, w, r); err != nil {
				Errorf(app.log, "Index HTTP GET %q", err.Error())
				return
			}
		}
	})
}

// This is HTTP POST handler for test cases.
func caseHTTPPostHandler(w http.ResponseWriter, r *http.Request, app *appinfo) error {

	id := mux.Vars(r)["id"]
	cmd := mux.Vars(r)["cmd"]

	var err error
	switch strings.ToLower(cmd) {

	case "":
		if c := parseCaseFormValues(r); c != nil {
			err = app.dbconn.InsertCase(c)
		}

	case "delete":
		if id == "" {
			return fmt.Errorf("Delete test case: test case ID is empty")
		}
		if err = app.dbconn.DeleteCase(id); err == nil {
			Infof(app.log, "Test case ID=%q successfully deleted", id)
		}

	case "put":
		if id == "" {
			return fmt.Errorf("Modify test case: test case ID is empty")
		}
		if c := parseCaseFormValues(r); c != nil {
			c.ID = MongoStringToID(id)
			if err = app.dbconn.ModifyCase(c); err == nil {
				Infof(app.log, "Test case '%s[%s]' successfully updated", c.CaseID, id)
			}
		}

	default:
		err = fmt.Errorf("Illegal POST request")
	}
	return err
}

// Helper function that parses the '/case' POST request values and creates a new instance of Case.
func parseCaseFormValues(r *http.Request) *Case {

	cid := strings.TrimSpace(r.FormValue("caseid"))
	name := strings.TrimSpace(r.FormValue("casename"))
	prio := strings.TrimSpace(r.FormValue("priority"))
	auto := strings.TrimSpace(r.FormValue("automated"))
	desc := strings.TrimSpace(r.FormValue("description"))
	exp := strings.TrimSpace(r.FormValue("expected"))
	note := strings.TrimSpace(r.FormValue("notes"))
	req := strings.TrimSpace(r.FormValue("reqid"))
	created := strings.TrimSpace(r.FormValue("created"))
	modified := strings.TrimSpace(r.FormValue("modified"))

	c := NewCase(cid, name)
	c.Desc = desc
	c.Expect = exp
	c.Notes = note
	c.ReqID = req
	c.Created = Timestamp(created)
	c.Modified = Timestamp(modified)
	if strings.ToLower(auto) == "yes" {
		c.Auto = true // by default, Auto is false...
	}
	c.Priority = core.PriorityFromString(prio)
	return c
}

// This is helper function that extracts the requirement IDs for test case forms...
func casesGetReqIDs(app *appinfo) []string {

	var reqs []string

	r, err := app.dbconn.GetRequirements("")
	if err != nil {
		return reqs
	}

	for _, item := range r {
		reqs = append(reqs, fmt.Sprintf("%s  %s", item.Short, item.Name))
	}
	return reqs
}

// This is HTTP GET handler for test cases.
func caseHTTPGetHandler(qry string, w http.ResponseWriter, r *http.Request, app *appinfo) error {

	c, err := app.dbconn.GetCases(qry)
	if err != nil {
		http.Redirect(w, r, "/err404", http.StatusFound)
		return fmt.Errorf("Problem getting cases from DB: '%s'", err.Error())
	}

	// get requirement IDs as a slice of strings
	req := casesGetReqIDs(app)

	// create ad-hoc struct to be sent to page template
	var web = struct {
		Cases []*Case
		Num   int
		Ptype string
		Reqs  []string
	}{c, len(c), "cases", req}

	return renderPage("cases", web, app, w, r)
}

// This is the default root and index.html handler function.
func indexHandler(app *appinfo) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		//if err := renderPage("index", UserName, app, w, r); err != nil {
		if err := renderPage("index", nil, app, w, r); err != nil {
			Error(app.log, err.Error())
			return
		}
	})
}

// This is the license page handler function.
func licHandler(app *appinfo) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		//if err := renderPage("license", UserName, app, w, r); err != nil {
		if err := renderPage("license", nil, app, w, r); err != nil {
			Error(app.log, err.Error())
			return
		}
	})
}

// This is the Error404 page handler function.
func err404Handler(app *appinfo) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if err := renderPage("err404", nil, app, w, r); err != nil {
			Error(app.log, err.Error())
			return
		}
	})
}

// This is handler that handler the "/requirement" URL.
func requirementHandler(app *appinfo) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		var err error

		switch r.Method {

		case "GET":
			if err = reqHTTPGetHandler("", w, r, app); err != nil {
				Errorf(app.log, "Requirement HTTP GET %q", err.Error())
			}

		case "POST":
			if err = reqHTTPPostHandler(w, r, app); err != nil {
				Errorf(app.log, "Requirement HTTP POST %q", err.Error())
			}
			// unconditionally reroute to main requirements page
			http.Redirect(w, r, "/requirement", http.StatusFound)

		case "DELETE":
			Infof(app.log, "Requirement HTTP DELETE request received. Redirecting to main 'requirements' page.")
			// unconditionally reroute to main test cases page
			// Use HTTP 303 (see other) to force GET to redirect as DELETE request is normally followed by another DELETE
			http.Redirect(w, r, "/requirement", http.StatusSeeOther)

		case "PUT":
			Infof(app.log, "Requirement HTTP PUT request received. Redirecting to main 'requirements' page.")
			// unconditionally reroute to main test cases page
			// Use HTTP 303 (see other) to force GET to redirect as PUT request is normally followed by another PUT
			http.Redirect(w, r, "/requirement", http.StatusSeeOther)

		default:
			if err := renderPage("index", nil, app, w, r); err != nil {
				Errorf(app.log, "Index HTTP GET %q", err.Error())
				return
			}
		}
	})
}

// This is HTTP POST handler for requirements.
func reqHTTPPostHandler(w http.ResponseWriter, r *http.Request, app *appinfo) error {

	id := mux.Vars(r)["id"]
	cmd := mux.Vars(r)["cmd"]

	var err error
	switch strings.ToLower(cmd) {

	case "":
		if req := parseReqFormValues(r); req != nil {
			err = app.dbconn.InsertRequirement(req)
		}

	case "delete":
		if id == "" {
			return fmt.Errorf("Delete requirement: ID is empty")
		}
		if err = app.dbconn.DeleteRequirement(id); err == nil {
			Infof(app.log, "Requirement %q successfully deleted", id)
		}

	case "put":
		if id == "" {
			return fmt.Errorf("Modify requirement: ID is empty")
		}
		if req := parseReqFormValues(r); req != nil {
			req.ID = MongoStringToID(id)
			if err = app.dbconn.ModifyRequirement(req); err == nil {
				Infof(app.log, "Requirement '%s [%s]' successfully updated", req.Short, id)
			}
		}

	default:
		err = fmt.Errorf("Illegal POST request for requirement")
	}
	return err
}

// Helper function that parses the '/requirement' POST request values and creates a new instance of Requirement.
func parseReqFormValues(r *http.Request) *Requirement {

	short := strings.TrimSpace(r.FormValue("short"))
	name := strings.TrimSpace(r.FormValue("name"))
	prio := strings.TrimSpace(r.FormValue("priority"))
	status := strings.TrimSpace(r.FormValue("reqstatus"))
	desc := strings.TrimSpace(r.FormValue("description"))
	created := strings.TrimSpace(r.FormValue("created"))
	modified := strings.TrimSpace(r.FormValue("modified"))

	req := NewRequirement(short, name)
	req.Description = desc
	req.Status = core.ReqStatusFromString(status)
	req.Priority = core.PriorityFromString(prio)
	req.Created = Timestamp(created)
	req.Modified = Timestamp(modified)
	return req
}

// This is HTTP GET handler for requirements.
func reqHTTPGetHandler(qry string, w http.ResponseWriter, r *http.Request, app *appinfo) error {

	reqs, err := app.dbconn.GetRequirements(qry)
	if err != nil {
		http.Redirect(w, r, "/err404", http.StatusFound)
		return fmt.Errorf("Problem getting requirements from DB: '%s'", err.Error())
	}
	// create ad-hoc struct to be sent to page template
	var web = struct {
		Reqs  []*Requirement
		Num   int
		Ptype string
	}{reqs, len(reqs), "reqs"}

	return renderPage("requirements", web, app, w, r)
}

// This is handler that handler the "/search" URL. It accepts only POST requests.
func searchHandler(app *appinfo) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		var err error
		switch r.Method {

		case "POST":
			if err = searchHTTPPostHandler(w, r, app); err != nil {
				Errorf(app.log, "Search HTTP POST %q", err.Error())
			}

		default:
			// otherwise just display main 'index' page
			if err := renderPage("index", nil, app, w, r); err != nil {
				Errorf(app.log, "Index HTTP GET %s", err.Error())
			}
		}
	})
}

// This is HTTP POST handler for searches.
func searchHTTPPostHandler(w http.ResponseWriter, r *http.Request, app *appinfo) error {

	qry := strings.TrimSpace(r.FormValue("search-string"))
	ptype := strings.TrimSpace(r.FormValue("search-type"))

	// if type is empty, we cannot do anything with it, just redirect to index page
	if ptype == "" {
		return renderPage("index", nil, app, w, r)
	}

	var err error
	switch strings.ToLower(ptype) {

	case "cases":
		err = caseHTTPGetHandler(qry, w, r, app)

	case "reqs":
		err = reqHTTPGetHandler(qry, w, r, app)

	default:
		// just render the /index page
		renderPage("index", nil, app, w, r)
	}
	return err
}
