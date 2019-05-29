package main

import (
	"log"
	"net/http"

	"github.com/yarsiemanym/wiki/lib"
)

func main() {

	http.HandleFunc("/view/", lib.MakeHandler(lib.View))
	http.HandleFunc("/edit/", lib.MakeHandler(lib.Edit))
	http.HandleFunc("/save/", lib.MakeHandler(lib.Save))
	http.Handle("/content/", http.StripPrefix("/content/", http.FileServer(http.Dir("content"))))
	http.Handle("/scripts/", http.StripPrefix("/scripts/", http.FileServer(http.Dir("scripts"))))
	http.HandleFunc("/", lib.FrontPage)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
