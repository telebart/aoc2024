package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"

main :: proc() {
  data, ok := os.read_entire_file_from_filename("1/input", context.allocator)
  if !ok {
    fmt.panicf("did not find input")
  }

  toggle := true
  left := [dynamic]int{}
  right := [dynamic]int{}
  start := 0
  end := 0
  for i := 0; i<len(data); i += 1 {
    end = i
    if data[i] == 10 {
      val_as_int, parse_ok := strconv.parse_int(string(data[start:end]))
      if !parse_ok {
        fmt.panicf("Failed to parse int from string:\"%s\"", string(data[start:end]))
      }
      append_elem(&right, val_as_int)

      start = i + 1

    } else if data[i] == 32 {
      val_as_int, parse_ok := strconv.parse_int(string(data[start:end]))
      if !parse_ok {
        fmt.panicf("Failed to parse int from string:\"%s\"", string(data[start:end]))
      }
      append_elem(&left, val_as_int)

      for data[i] == 32 {
        i += 1
      }
      start = i
    }
  }

  sum := 0
  for key in left {
    count := 0
    for elem in right {
      if elem == key do count += 1
    }
    sum += key*count
  }
  fmt.println(sum)
}
