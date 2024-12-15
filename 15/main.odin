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
  instructions := data[split_i+2:]
  dynamic_warehouse := make([dynamic]byte)
  for b in data[:split_i] {
    if b == '#' || b == '.' {
      append(&dynamic_warehouse, b)
      append(&dynamic_warehouse, b)
    } else if b == '@' {
      append(&dynamic_warehouse, '@')
      append(&dynamic_warehouse, '.')
    } else if b == 'O' {
      append(&dynamic_warehouse, '[')
      append(&dynamic_warehouse, ']')
    } else if b == '\n'{
      append(&dynamic_warehouse, b)
    }else {
      fmt.panicf("what is even %v", rune(b))
    }
  }

  warehouse := dynamic_warehouse[:]
  robo := slice.linear_search(warehouse[:], '@') or_else panic("no robo")
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
    if b == ']' {
      x := i%(warehouse_width+1) - 1
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


  if warehouse[next] == '[' || warehouse[next] == ']' {
    push_arr: [dynamic][2]int
    defer delete_dynamic_array(push_arr)
    append(&push_arr, [2]int{next, int(warehouse[next])})
    if dir&1 == 1 {
      behind := next + dirs[dir]
      for {
        block = is_blocking(warehouse, behind)
        if block == '.' do break
        if block == '#' do return loc
        append(&push_arr, [2]int{behind, int(warehouse[behind])})
        behind += dirs[dir]
      }

      #reverse for box in push_arr {
        warehouse[box.x+dirs[dir]] = byte(box.y)
      }
      warehouse[loc] = '.'
      warehouse[next] = '@'
      return next
    } else {
      if warehouse[next] == '[' {
        append(&push_arr, [2]int{next, '['})
        append(&push_arr, [2]int{next + dirs[1], ']'})
      } else {
        append(&push_arr, [2]int{next, ']'})
        append(&push_arr, [2]int{next + dirs[3], '['})
      }
      move_ok := get_vertical_behind(warehouse, push_arr[:], &push_arr, dir)
      if !move_ok do return loc
      #reverse for p in push_arr {
        warehouse[p.x] = '.'
        warehouse[p.x+dirs[dir]] = byte(p.y)
      }
      warehouse[loc] = '.'
      warehouse[next] = '@'
      return next
    }
  } else if warehouse[next] == '.' {
    warehouse[loc] = '.'
    warehouse[next] = '@'
    return next
  }

  fmt.panicf("how did we get here", loc, dir, string(warehouse^))
}

get_vertical_behind :: proc(warehouse: ^[]byte, check: [][2]int, push_arr: ^[dynamic][2]int, dir: int) -> bool {
  count := 0
  for x in check {
    behind := x.x + dirs[dir]
    block := is_blocking(warehouse, behind)
    if block == '#' do return false
    if block == '.' do continue

    count += 2
    if block == '[' {
      append(push_arr, [2]int{behind, '['})
      append(push_arr, [2]int{behind+dirs[1], ']'})
    } else {
      append(push_arr, [2]int{behind, ']'})
      append(push_arr, [2]int{behind+dirs[3], '['})
    }
  }
  if count > 0 {
    return get_vertical_behind(warehouse, push_arr[len(push_arr)-count:], push_arr, dir)
  }
  return true
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
