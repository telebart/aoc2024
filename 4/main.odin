package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:slice"
import "core:bytes"

main :: proc() {
  data := os.read_entire_file_from_filename("4/input") or_else os.exit(1337)

  grid: [dynamic][dynamic]byte
  row_helper: [dynamic]byte

  for b in data {
    if b == byte('\n') {

      append(&grid, slice.clone_to_dynamic(row_helper[:]))

      clear_dynamic_array(&row_helper)
      continue
    }

    append(&row_helper, b)
  }


  count := 0
  for row, i in grid {
    for _, j in row {
      if grid[j][i] == byte('A') {
        if find_x_mas(grid[:], {i,j}) do count +=1
      }
    }
  }
  fmt.println(count)
}

find_x_mas :: proc(grid: [][dynamic]byte, loc: [2]int) -> bool {
  checks := [2][2][2]int{
    {
      {-1,+1},
      {+1,-1},
    },
    {
      {+1,+1},
      {-1,-1},
    }
  }

  for check in checks {
    r, ok := get_rune(grid, loc + check[0]).?
    if !ok do return false

      look_for: u8
      switch r {
        case 'M':
          look_for = 'S'
        case 'S':
          look_for = 'M'
        case:
          return false
      }

      if !look_for_rune(grid, loc + check[1], look_for) do return false
  }

  return true
}

look_for_rune :: proc(grid: [][dynamic]byte, loc: [2]int, look_for: u8) -> bool {
  r, ok := get_rune(grid, loc).?
  if !ok do return false
  if r == look_for do return true
  return false
}

get_rune :: proc(grid: [][dynamic]byte, loc: [2]int) -> Maybe(u8) {
  if loc.x < 0 || loc.y < 0 do return nil
  if loc.y >=len(grid) || loc.x >= len(grid[loc.y]) do return nil
  return grid[loc.y][loc.x]
}
