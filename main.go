package main

import (
	"log"
	"net/http"
)

func main() {

	http.HandleFunc("/view/", makeHandler(viewHandler))
	http.HandleFunc("/edit/", makeHandler(editHandler))
	http.HandleFunc("/save/", makeHandler(saveHandler))
	http.HandleFunc("/", frontPageHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
