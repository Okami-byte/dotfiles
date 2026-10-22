package main

import (
	"fmt"
	"github.com/fullerzz/herdr-plugin-sesh/internal/config"
)

func main() {
	cfg, path, err := config.Load(config.LoadOptions{Path: ""})
	fmt.Printf("path=%q err=%v\n", path, err)
	fmt.Printf("preview=%q\n", cfg.DefaultSessionConfig.PreviewCommand)
}
