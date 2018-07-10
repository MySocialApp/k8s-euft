package main

import (
	"os"
	"io/ioutil"
	"github.com/smallfish/simpleyaml"
	"fmt"
	"strings"
	"os/exec"
	"bufio"
)

func setEnv(envvar string) {
	fmt.Println("\n[+] Adding to environment variables: " + envvar)
	vars := strings.Split(envvar, " ")

	for i := range vars {
		currentVar := strings.Split(vars[i], "=")

		// If PATH => prefix
		if currentVar[0] == "PATH" {
			os.Setenv(currentVar[0], strings.Replace(currentVar[1], "\"", "", -1) + ":" + os.Getenv("PATH"))
		} else {
			os.Setenv(currentVar[0], currentVar[1])
		}
		//fmt.Println(os.Getenv(currentVar[0]))
	}
}

func runCmd(command string) {
	fmt.Println("\n[+] Running command: " + command)

	// Prepare cmd to run with args
	cmdArgs := strings.Fields(command)
	cmd := exec.Command(cmdArgs[0], cmdArgs[1:len(cmdArgs)]...)

	// Stream lines output to stdout
	stdout, _ := cmd.StdoutPipe()
	cmd.Start()

	scanner := bufio.NewScanner(stdout)
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		m := scanner.Text()
		fmt.Println(m)
	}
	cmd.Wait()
}

func runSection(yaml simpleyaml.Yaml, key string) {
	list, _ := yaml.Get(key).Array()
	for item := range list {
		current, _ := yaml.Get(key).GetIndex(item).String()
		switch key {
		case "install":
			runCmd(current)
		case "script":
			runCmd(current)
		case "after_script":
			runCmd(current)
		}
	}
}

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: travis-exec <travis_file> <travis_field>")
		fmt.Println("Example: go run tests/k8s-euft/travis-exec.go .travis.yml")
		os.Exit(1)
	}
	filename := os.Args[1]

	source, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}

	yaml, err := simpleyaml.NewYaml(source)
	if err != nil {
		panic(err)
	}

	// Run all tests (install/script...) for all envs
	allEnv, _ := yaml.Get("env").Array()
	keys, err := yaml.GetMapKeys()

	for currentIndex := range allEnv {
		envName, _ := yaml.Get("env").GetIndex(currentIndex).String()
		setEnv(envName)
		for key := range keys {
			runSection(*yaml, keys[key])
		}
	}
}
