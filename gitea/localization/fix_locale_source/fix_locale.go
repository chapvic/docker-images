package main

import (
    "flag"
    "fmt"
    "os"
    "gopkg.in/ini.v1"
)

var (
    in  string
    mod string
    out string
)

func main() {
    initFlag()
    if flag.NFlag() == 0 {
        fmt.Println("No arguments given!\nUse -f for help screen")
        os.Exit(0)
    }

    if in == "" {
        panic("No inpit file defined!")
    }
    if mod == "" {
        panic("No mod file defined!")
    }
    if out == "" {
        panic("No output file defined!")
    }

    //ini, err := ini.Load(in, mod)
    ini, err := ini.LoadSources(
        ini.LoadOptions{
            Loose: true,
            PreserveSurroundedQuote: true,
            IgnoreInlineComment: true,
        }, in, mod)
    if err != nil {
        fmt.Printf("Fail to read file: %v", err)
        os.Exit(1)
    }

    err = ini.SaveTo(out)
    if err != nil {
        fmt.Printf("Fail to read file: %v", err)
        os.Exit(1)
    }
}

func initFlag() {
    flag.StringVar(&in, "in", "", "input ini-file with translations.")
    flag.StringVar(&mod, "mod", "", "input ini-file with fixed translations.")
    flag.StringVar(&out, "out", "", "output ini-file with result.")
    flag.Parse()
}
