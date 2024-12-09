package main

import "core:os"
import "core:fmt"
import "core:slice"


dirs: [4]int
original_pos: int

main :: proc() {
  data := os.read_entire_file_from_filename("6/input") or_else panic("no input file")

  line_break_i, ok := slice.linear_search(data, '\n')
  if !ok do panic("")

  guard, ok2 := slice.linear_search(data, '^')
  if !ok2 do panic("")
  original_pos = guard

  dirs = {
    -line_break_i-1,
    1,
    line_break_i+1,
    -1,
  }
  cur_dir := 0

  loops := 0
  cant_place := [dynamic]int{guard}
  for {
    move := guard + dirs[cur_dir]
    if move < 0 || move >= len(data) || data[move] == '\n' do break

    if data[move] == '.' && !slice.contains(cant_place[:], move) {
      data[move] = 'O'
      if search_loop(data[:], guard, cur_dir) {
        loops += 1
      }
      append_elem(&cant_place, move)
      data[move] = '.'
    }

    if data[move] == '#' {
        cur_dir = (cur_dir + 1) % 4
        continue
    }
    guard = move
  }

  fmt.println(loops)
}

loop_add :: proc(l: ^[dynamic][2]int, x: [2]int) -> bool {
  if len(l) >= 4 && slice.contains(l[:], x) {
    return true
  }
  append_elem(l, x)

  return false
}

search_loop :: proc(data: []byte, guard, cur_dir: int) -> bool {
  loop := [dynamic][2]int{
    {guard, cur_dir}
  }
  defer delete_dynamic_array(loop)
  cur_dir := (cur_dir + 1) % 4
  guard := guard
  for {
    move := guard + dirs[cur_dir]

    if move < 0 || move >= len(data) || data[move] == '\n' do return false
    if data[move] == '#' || data[move] == 'O' {
      if loop_add(&loop, [2]int{move, cur_dir}) do return true
      cur_dir = (cur_dir + 1) % 4
      continue
    }

    guard = move
  }
}
