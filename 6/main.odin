package main

import "core:os"
import "core:fmt"
import "core:slice"


x := 69

main :: proc() {
  data := os.read_entire_file_from_filename("6/input") or_else panic("no input file")

  line_break_i, ok := slice.linear_search(data, '\n')
  if !ok do panic("")

  guard, ok2 := slice.linear_search(data, '^')
  if !ok2 do panic("")

  dirs := [?]int{
    -line_break_i-1,
    1,
    line_break_i+1,
    -1,
  }
  cur_dir := 0

  visited := 1
  for {
    move := guard + dirs[cur_dir]

    if move < 0 || move >= len(data) || data[move] == '\n' do break
    if data[move] == '#' {
        cur_dir = (cur_dir + 1) % 4
        continue
    }
    if data[move] == '.' {
      visited += 1
      data[move] = 'X'
    }
    guard = move
  }

  fmt.println(visited)
}
