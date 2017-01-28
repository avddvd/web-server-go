package main

import (
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"strings"
)

var MaxQueue int

type HttpServer struct {
	httpListener net.Listener
	config       map[string]string
}

// New HttpServer
func NewHttpServer(c map[string]string) *HttpServer {
	http.DefaultServeMux = &http.ServeMux{}
	return &HttpServer{
		config: c,
	}
}

// handlers
func healthCheck(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "healthy")
}

func defaultHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusNotFound)
}

func (hs *HttpServer) setHandlers() {

	http.HandleFunc("/", defaultHandler)

	// health-check:
	http.HandleFunc("/healthz", healthCheck)

}

func (hs *HttpServer) Start() {

	// set handlers
	hs.setHandlers()
	log.Println("starting server ...")
	var err error
	hs.httpListener, err = net.Listen("tcp", ":"+hs.config["HTTP_PORT"])
	if err != nil {
		log.Fatal("Could not setup http listener.\n", err, hs.config)
	}
	http.Serve(hs.httpListener, nil)
}

// util funcs
func mapOf(slice []string, delimiter string) map[string]string {
	m := map[string]string{}
	for _, e := range slice {
		a := strings.Split(e, delimiter)
		m[a[0]] = a[1]
	}
	return m
}

func main() {

	// start hs Server
	config := mapOf(os.Environ(), "=")
	log.Println("Config:", config)
	NewHttpServer(config).Start()
}
