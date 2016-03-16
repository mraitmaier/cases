package main

// Page type represents the current web page
type Page struct {

	// This is the data part of current web page
	Data interface{}

	// This is optional (error, warning etc.) message; normally, it's empty
	Msg string
}
