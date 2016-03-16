package main

import (
	"fmt"
	"log"
	"os"
	"path"
	"path/filepath"
	"runtime"
)

const (
	// DefaultLogFileName defines the default filename for the log.
	DefaultLogFileName = "cases.log"
)

// CreateDefaultLogPath creates the default path for the logfile (when default paramter is empty).
// The default path is platform dependant: for Windows, this is '%USERPROFILE%/cases/'; for Linux, this is '$HOME/cases/'
func CreateDefaultLogPath() string {

	var prfl string
	switch runtime.GOOS {

	case "windows":
		prfl = os.Getenv("USERPROFILE")

	case "linux", "bsd":
		prfl = os.Getenv("HOME")
	}

	defpath := filepath.Clean(path.Join(prfl, "cases", DefaultLogFileName))
	return defpath
}

// CreateLogFile creates a new file logger.
func CreateLogFile(logpath, prefix string, flags int) (*log.Logger, *os.File, error) {

	// create container folder, when it doesn't exist; if exists, MkdirAll() does nothing...
	err := os.MkdirAll(filepath.Dir(logpath), 0644)
	if err != nil {
		return nil, nil, err
	}

	f, err := os.Create(logpath)
	//f, err = os.OpenFile(path, os.O_CREATE | os.O_RDWR | os.O_APPEND, 0755)
	if err != nil {
		return nil, nil, err
	}

	if flags == 0 {
		flags = log.LstdFlags
	}
	return log.New(f, prefix, flags), f, nil
}

// CloseLogFile safely closes the log file.
func CloseLogFile(f *os.File) {

	if f == nil {
		return
	}
	f.Close()
}

/*

// SetStdFlags forces logger to use the standard timestamp flags. It's basically sets log.LstdFlags to logger..
func SetStdFlags(l *log.Logger) {

    if l == nil { return }
    l.SetFlags(log.LstdFlags)
}

// SetShortFile forces the logger to use the short filenames as part of the log message.
func SetShortFile(l *log.Logger) {

    if l == nil { return }
    l.SetFlags( l.Flags() | log.Lshortfile)
}

// SetLongFile forces the logger to use the long filenames (absolute path) as part of the log message.
func SetLongFile(l *log.Logger) {

    if l == nil { return }
    l.SetFlags( l.Flags() | log.Llongfile)
}
*/

// Debugf is ...
func Debugf(log *log.Logger, format string, v ...interface{}) {
	s := fmt.Sprintf("DEBUG %s", format)
	log.Printf(s, v)
}

// Infof is ...
func Infof(log *log.Logger, format string, v ...interface{}) {
	s := fmt.Sprintf("INFO %s", format)
	log.Printf(s, v)
}

// Noticef is ...
func Noticef(log *log.Logger, format string, v ...interface{}) {
	s := fmt.Sprintf("NOTICE %s", format)
	log.Printf(s, v)
}

// Warningf is ...
func Warningf(log *log.Logger, format string, v ...interface{}) {
	s := fmt.Sprintf("WARNING %s", format)
	log.Printf(s, v)
}

// Errorf is ...
func Errorf(log *log.Logger, format string, v ...interface{}) {
	s := fmt.Sprintf("ERROR %s", format)
	log.Printf(s, v)
}

// Critf is ...
func Critf(log *log.Logger, format string, v ...interface{}) {
	s := fmt.Sprintf("CRIT %s", format)
	log.Printf(s, v)
}

// Alertf is ...
func Alertf(log *log.Logger, format string, v ...interface{}) {
	s := fmt.Sprintf("ALERT %s", format)
	log.Printf(s, v)
}

// Emergf is ...
func Emergf(log *log.Logger, format string, v ...interface{}) {
	s := fmt.Sprintf("EMERG %s", format)
	log.Printf(s, v)
}

// Debug is ...
func Debug(log *log.Logger, msg string) { log.Printf(fmt.Sprintf("DEBUG %s", msg)) }

// Info is ...
func Info(log *log.Logger, msg string) { log.Printf(fmt.Sprintf("INFO %s", msg)) }

// Notice is ...
func Notice(log *log.Logger, msg string) { log.Printf(fmt.Sprintf("NOTICE %s", msg)) }

// Warning is ...
func Warning(log *log.Logger, msg string) { log.Printf(fmt.Sprintf("WARNING %s", msg)) }

// Error is ...
func Error(log *log.Logger, msg string) { log.Printf(fmt.Sprintf("ERROR %s", msg)) }

// Crit is ...
func Crit(log *log.Logger, msg string) { log.Printf(fmt.Sprintf("CRIT %s", msg)) }

// Alert is ...
func Alert(log *log.Logger, msg string) { log.Printf(fmt.Sprintf("ALERT %s", msg)) }

// Emerg is ...
func Emerg(log *log.Logger, msg string) { log.Printf(fmt.Sprintf("EMERG %s", msg)) }
