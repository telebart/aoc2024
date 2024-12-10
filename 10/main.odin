package main

import "core:os"
import "core:fmt"
import "core:slice"


main :: proc() {
  data := os.read_entire_file_from_filename("10/input") or_else panic("no input file")
  width := slice.linear_search(data, '\n') or_else panic("no line breaks")

  directions = [direction]int {
    .N = -width-1,
    .W = -1,
    .S = width+1,
    .E = 1,
  }

  i := 0
  trailheads: [dynamic]int
  total := 0
  for b, i in data{
    if data[i] == '0' {
      find_trailheads(data, i, &total)
      total += len(trailheads)
    }
  }
  fmt.println(total)
}

find_trailheads :: proc(mountain: []byte, cur_pos: int, total: ^int) {
  next := mountain[cur_pos] + 1
  for dir in direction {
    move := directions[dir] + cur_pos
    if move < 0 || move >= len(mountain) || mountain[move] == '\n' do continue
    if mountain[move] != next do continue
    if next == '9'{
      total^ += 1
    } else {
      find_trailheads(mountain, move, total)
    }
  }
}

directions: [direction]int
direction :: enum {
  N,
  W,
  S,
  E,
}

