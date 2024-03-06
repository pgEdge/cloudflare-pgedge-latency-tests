package main

import (
	"context"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

func main() {

	ctx, cancel := context.WithTimeout(context.Background(), time.Minute)
	defer cancel()

	var count int
	var urlStr string
	flag.IntVar(&count, "count", 100, "Number of requests to make")
	flag.StringVar(&urlStr, "url", "", "URL to access")
	flag.Parse()

	if urlStr == "" {
		log.Fatal("please specify a url")
	}

	hostname, err := os.Hostname()
	if err != nil {
		log.Fatal(err)
	}

	req, err := http.NewRequestWithContext(ctx, "GET", urlStr, nil)
	if err != nil {
		log.Fatal(err)
	}

	times := make([]time.Duration, count)

	for i := 0; i < count; i++ {
		start := time.Now()
		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			log.Fatal(err)
		}
		if _, err := io.ReadAll(resp.Body); err != nil {
			log.Fatal(err)
		}
		resp.Body.Close()
		dt := time.Since(start)
		times[i] = dt
	}

	var sum time.Duration
	for _, dt := range times {
		sum += dt
	}
	avg := sum / time.Duration(count)

	fmt.Println("hostname:", hostname)
	fmt.Println("request url:", urlStr)
	fmt.Println("request count:", count)
	fmt.Println("average latency:", avg)
}
