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

  designs := strings.split_lines(instructions[1])
  total: int
  for design, i in designs {
    total += complete_design(design)
  }

  fmt.println(total)
}

memo: map[memo_item]int
memo_item :: struct {
  d: string,
  e: int,
}

complete_design :: proc(design: string, end: int = 0) -> int {
  if val, ok := memo[{design, end}]; ok { return val }
  if end > len(design) do return 0
  if _, ok := patterns[design[:end]]; ok || end == 0 {
    if len(design) == end {
      return 1
    }
    sum := 0
    for i in 0..<max(len(design), max_pattern_len) {
      sum += complete_design(design[end:], i+1)
    }
    memo[{design, end}] = sum
    return sum
  }
  return 0
}
