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
      sort_append(&right, data[start:end])

      start = i + 1

    } else if data[i] == 32 {
      sort_append(&left, data[start:end])

      for data[i] == 32 {
        i += 1
      }
      start = i
    }
  }

  sum := 0
  for v, i in left {
    sum += math.abs(v - right[i])
  }
  fmt.println(sum)
}

sort_append :: proc(xs: ^[dynamic]int, val: []byte) {
  val_as_int, parse_ok := strconv.parse_int(string(val))
  if !parse_ok {
    fmt.panicf("Failed to parse int from string:\"%s\"", string(val))
  }

  i := 0
  for i < len(xs) && val_as_int > xs[i] {
    i += 1
  }

  inject_at_elem(xs, i, val_as_int)
}
