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

  directions :: [8][2]int {
    {+0,+1},
    {+1,+1},
    {+1,+0},
    {+1,-1},
    {+0,-1},
    {-1,-1},
    {-1,+0},
    {-1,+1},
  }

  count := 0
  for row, i in grid {
    for _, j in row {
      if grid[j][i] == byte('X') {
        for d in directions {
          if find_christmas(grid[:], {i,j}, d) do count +=1
        }
      }
    }
  }
  fmt.println(count)
}

find_christmas :: proc(grid: [][dynamic]byte, loc: [2]int, dir: [2]int) -> bool {
  tail := "MAS"
  cur := loc
  for r in tail {
    cur += dir
    if cur.x < 0 || cur.y < 0 do return false
    if cur.y >=len(grid) || cur.x >= len(grid[cur.y]) do return false
    if grid[cur.y][cur.x] != byte(r) do return false
  }
  fmt.println("christmas found with loc:", loc, "and dir:", dir)
  return true
}
