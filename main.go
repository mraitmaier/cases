package main

import (
	"fmt"
	"html/template"
	"log"
	"os"
	"os/signal"
)

// Type appinfo is a global struct that holds all necessary information for application to normally run
type appinfo struct {

	// working folder
	//WorkDir string

	// a log filename
	LogFilename string

	// open logfile handle
	logfile *os.File

	// a syslog IP address
	//SyslogIP string

	// a logger
	log *log.Logger

	// We need page templates; these are cached at app initialization
	templates *template.Template

	// MongoDB connection
	dbconn *MongoDBConnection

	// folder for session files
	SessDir string

	// Msg is a text that will be displayed on web page
	Msg *Message

	// a debug flag (only for testing purposes)
	Debug bool
}

// Cleaup before exit.
func (a *appinfo) Cleanup() {

	fmt.Println("Closing connection to DB.")
	CloseDB(a.dbconn)
	fmt.Printf("Closing log file %q.", a.LogFilename)
	CloseLogFile(a.logfile)
}

func main() {
	fmt.Println("Starting...")

	// create app global var; keep it secret, keep it safe...
	app := new(appinfo)
	Init(app)
	defer app.Cleanup()

	// catch CTRL-C signal and perform cleanup before app is terminated
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, os.Kill)
	go func() {
		<-c
		fmt.Println("Stop.")
		app.Cleanup()
		os.Exit(0) // CTRL-C is clean exit for this app...
	}()

	// start web interface
	fmt.Println("Serving the application on port 8888...")
	if err := webStart(app, DefWebRoot); err != nil {
		return
	}

	//fmt.Println("Stop.")
}

// Init is usual application initialization function.
func Init(app *appinfo) {

	app.Debug = false // no debug mode by default

	var err error
	app.LogFilename = CreateDefaultLogPath()
	if app.log, app.logfile, err = CreateLogFile(app.LogFilename, "", 0); err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		panic(">> Log file cannot be created. Exiting...")
	}
	Info(app.log, "Log successfully created")
	fmt.Printf("Logging to %q.\n", app.LogFilename)

	var cfg *Cfg
	if cfg, err = readCfg(DefConfigFileName); err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		panic(">> The config file cannot be parsed. Exiting...")
	}
	Info(app.log, "Configuration successfully parsed")

	//if app.dbconn, err = ConnectDB(DefDBHost, DefDBPort, DefDBUser, DefDBPwd, DefDBName, DefDBTimeout); err != nil {
	if app.dbconn, err = ConnectDB(cfg); err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		panic(">> Connection to MongoDB cannot be established.")
	}
	Info(app.log, "DB connection successfully established")
}

// Message is a
type Message struct {

	// Severity and Text are string that define message: Severity is severity level, while
	// Text is, of course, the actual text that will be displayed.
	Severity, Text string
}

// NewMessage creates new empty message.
func NewMessage() *Message { return &Message{"", ""} }

// Set defines new Message.
func (m *Message) Set(sev, text string) {
	m.Severity = sev
	m.Text = text
}

// Reset clears the Message contents.
func (m *Message) Reset() { m = NewMessage() }
