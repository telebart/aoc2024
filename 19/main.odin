package main

import "core:os"
import "core:strings"
import "core:fmt"


void :: struct{}
max_pattern_len := -1

patterns: map[string]void

main :: proc() {
  data := os.read_entire_file("19/input") or_else panic("no input")
  instructions := strings.split(string(data[:len(data)-1]), "\n\n")

  for pattern in strings.split_iterator(&instructions[0], ",") {
    p := strings.trim_space(pattern)
    max_pattern_len = max(len(p), max_pattern_len)
    patterns[p] = void{}
  }

  possibles := 0
  designs := strings.split_lines(instructions[1])
  for design in designs {
    if complete_design(design) do possibles += 1
  }

  fmt.println(possibles)
}

complete_design :: proc(design: string, end: int = 0) -> bool {
  if end > len(design) do return false
  if _, ok := patterns[design[:end]]; ok || end == 0 {
    if len(design) == end do return true
    for i in 0..<max(len(design), max_pattern_len) {
       if complete_design(design[end:], i+1) do return true
    }
  }
  return false
}
