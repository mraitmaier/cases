package main

/*
 */

import (
	"encoding/json"
	_ "fmt"
	"os"
)

// This is default name for the configuration file.
var DefConfigFileName = "config.json"

// Cfg type is a helper type that is used to temporarily save the DB connection part of the configuration.
type Cfg struct {

	//
	DB struct {
		Name, Host, Port, User, Passwd string
		Timeout                        int
	} `json:"Database"`
}

// function newCfg is used to initialize empty config structure.
func newCfg() *Cfg {
	c := new(Cfg)
	c.DB.Name = DefDBName
	c.DB.Host = DefDBHost
	c.DB.Port = DefDBPort
	c.DB.User = DefDBUser
	c.DB.Passwd = DefDBPwd
	c.DB.Timeout = DefDBTimeout
	return c
}

// Function readCfg is used to read JSON configuration file and decode it.
func readCfg(fname string) (*Cfg, error) {

	file, err := os.Open(fname)
	if err != nil {
		return nil, err
	}

	decoder := json.NewDecoder(file)
	if err != nil {
		return nil, err
	}

	cfg := newCfg()
	err = decoder.Decode(cfg)

	//fmt.Printf("DEBUG readCfg() cfg=%v\n", cfg) // DEBUG
	return cfg, nil
}
