package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:time"

dirs: [4]int

main :: proc() {
  data := os.read_entire_file_from_filename("15/input") or_else panic("no input")
  split_i := search_double_line_break(data)
  warehouse := data[:split_i]
  instructions := data[split_i+2:]

  robo := slice.linear_search(warehouse, '@') or_else panic("no robo")
  warehouse_width := slice.linear_search(warehouse, '\n') or_else panic("no line break")

  dirs = {
    -warehouse_width-1,
    1,
    warehouse_width+1,
    -1,
  }

  for ins in instructions {
    if ins == '\n' do continue

    switch ins {
      case '^':
        robo = handle_move(&warehouse, robo, 0)
      case '>':
        robo = handle_move(&warehouse, robo, 1)
      case 'v':
        robo = handle_move(&warehouse, robo, 2)
      case '<':
        robo = handle_move(&warehouse, robo, 3)
      case:
        fmt.panicf("can't handle %v", ins)
    }
  }

  total: int
  for b, i in warehouse {
    if b == 'O' {
      x := i%(warehouse_width+1)
      y := i/(warehouse_width+1)
      total += 100*y + x
    }
  }
  fmt.println(string(warehouse))
  fmt.println(total)
}

handle_move :: proc(warehouse: ^[]byte, loc,dir: int) -> int {
  next := loc + dirs[dir]
  block := is_blocking(warehouse, next)
  if block == '#' do return loc


  if warehouse[next] == 'O' {
    behind := next + dirs[dir]
    for {
      block = is_blocking(warehouse, behind)
      if block == '.' do break
      if block == '#' do return loc
      behind += dirs[dir]
    }

    warehouse[loc] = '.'
    warehouse[next] = '@'
    warehouse[behind] = 'O'
    return next

  } else if warehouse[next] == '.' {
    warehouse[loc] = '.'
    warehouse[next] = '@'
    return next
  }

  fmt.panicf("how did we get here", loc, dir, string(warehouse^))
}

is_blocking :: proc(warehouse: ^[]byte, loc: int) -> byte {
  if loc < 0 || loc >= len(warehouse) do return '#'
  if warehouse[loc] == '\n' do return '#'
  return warehouse[loc]
}

search_double_line_break :: proc(data: []byte) -> int {
  data_i := 0
  prev_split_index := -1
  for d, i in data {
    if d == '\n' {
      if i - prev_split_index == 1 {
        return prev_split_index
      }
      prev_split_index = i
    }
  }
  panic("no double line break")
}
