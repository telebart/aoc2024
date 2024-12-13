package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math/linalg"
import "core:math/fixed"
import "core:math"
import "core:mem"


main :: proc() {
  data := os.read_entire_file_from_filename("13/input") or_else panic("no input")
  equations := strings.split(string(data[:len(data)-1]), "\n\n")

  total := 0
  for equation in equations {
    lines := strings.split_lines(equation)
    button_sep := []string{"+", ","}
    prize_sep := []string{"=", ","}
    a := split_xy(lines[0], button_sep)
    b := split_xy(lines[1], button_sep)
    prize := split_xy(lines[2], prize_sep)
    prize += 1e13

    left := matrix[2,2]f64{
      a.x, a.y,
      b.x, b.y,
    }
    ileft := matrix[2,2]f64{
      b.y, -b.x,
      -a.y, a.x,
    }

    solved := 1/linalg.determinant(left) * ileft * prize
    if abs(solved.x - math.round(solved.x)) > 0.0003 || abs(solved.y - math.round(solved.y)) > 0.0003 {
      continue
    }

    tokens := int(math.round(solved.x)) * 3 + int(math.round(solved.y))
    total += tokens
  }
  fmt.println(total)
}

split_xy :: proc(line: string, sep: []string) -> [2]f64 {
  split := strings.split_multi(line, sep)
  x := strconv.parse_f64(split[1]) or_else panic("parse int")
  y := strconv.parse_f64(split[3]) or_else panic("parse int")
  return {x, y}
}
