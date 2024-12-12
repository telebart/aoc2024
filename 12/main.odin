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
  for d, i in data {
    if d == '\n' do continue

    switch d {
    case 'A'..='Z':
      gg: [2]int
      calculate_garden_group(&data, i, d, &gg)
      total += gg.x * gg.y
    }
  }

  fmt.println(total)
}

calculate_garden_group :: proc(data: ^[]byte, loc: int, region: byte, gg: ^[2]int) {
  data[loc] = region + VISITED_OFFSET
  gg.x += 1

  for dir in dirs {
    cell := loc + dir
    if cell < 0 || cell >= len(data) || data[cell] == '\n' {
      gg.y += 1
    } else if data[cell] == region + VISITED_OFFSET {
      continue
    } else if data[cell] == region {
      calculate_garden_group(data, cell, region, gg)
    } else {
      gg.y += 1
    }
  }
}

