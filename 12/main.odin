package main

import "core:os"
import "core:fmt"
import "core:slice"

dirs: [4]int
VISITED_OFFSET :: 26

main :: proc() {
  data := os.read_entire_file_from_filename("12/input") or_else panic("no input")

  width := slice.linear_search(data, '\n') or_else panic("no line breaks")
  dirs = [4]int{
    -width -1,
    1,
    width+1,
    -1
  }

  total := 0
  sides: map[[2]int]bool
  for d, i in data {
    if d == '\n' do continue

    switch d {
    case 'A'..='Z':
      gg := GG{0, sides}
      calculate_garden_group(&data, i, d, &gg)
      sides := calculate_sides(&gg.sides)
      total += gg.area * sides
    }
  }

  fmt.println(total)
}

GG :: struct {
  area: int,
  sides: map[[2]int]bool,
}

calculate_sides :: proc(sides: ^map[[2]int]bool) -> int {
  total := 0
  for key in sides {
    total += 1

    left := dirs[(key.y + 3) % 4]
    next_key := [2]int{key.x + left, key.y}
    for {
      dir2 := sides[next_key] or_break
      delete_key(sides, next_key)
      next_key.x += left
    }

    right := dirs[(key.y + 1) % 4]
    next_key = {key.x + right, key.y}
    for {
      dir2 := sides[next_key] or_break
      delete_key(sides, next_key)
      next_key.x += right
    }

    delete_key(sides, key)
  }
  return total
}

calculate_garden_group :: proc(data: ^[]byte, loc: int, region: byte, garden_group: ^GG) {
  data[loc] = region + VISITED_OFFSET
  garden_group.area += 1

  for dir, i in dirs {
    cell := loc + dir
    if cell < 0 || cell >= len(data) || data[cell] == '\n' {
      garden_group.sides[{cell, i}] = true
    } else if data[cell] == region + VISITED_OFFSET {
      continue
    } else if data[cell] == region {
      calculate_garden_group(data, cell, region, garden_group)
    } else {
      garden_group.sides[{cell, i}] = true
    }
  }
}

