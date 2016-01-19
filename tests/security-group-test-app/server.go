package main

import (
	"github.com/go-martini/martini"
	"net/http"
)

// This server attempts to ping the NIST 800-53 website for testing
func main() {
	m := martini.Classic()
	m.Get("/", func() string {
		_, err := http.Get("https://web.nvd.nist.gov/view/800-53/home")
		if err != nil {
			return "Failed"
		}
		return "Success"
	})
	m.Run()
}
