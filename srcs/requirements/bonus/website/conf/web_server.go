package main

import (
    "fmt"
    "log"
    "net/http"
)

func main() {
    fs := http.FileServer(http.Dir("./public"))

    http.Handle("/", fs)

    port := ":1313"
    fmt.Printf("Starting static website on http://localhost%s\n", port)
    
    err := http.ListenAndServe(port, nil)
    if err != nil {
        log.Fatal(err)
    }
}