package main

import "os"
import "os/exec"
import "syscall"

func main(){
  binary, _ := exec.LookPath("ls")
  
  env := os.Environ()
  args := []string{"ls", "-ltr"}
  execErr := syscall.Exec(binary, args, env)
  if execErr != nil {
    panic(execErr)
  }
}
