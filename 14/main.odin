package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

WIDTH :: 101
HEIGHT :: 103
SECONDS :: 100

main :: proc() {
  data := os.read_entire_file_from_filename("14/input") or_else panic("no input")

  lines := strings.split_lines(string(data[:len(data)-1]))

  quarters: [4]int
  for line in lines {
    split := strings.split_multi(line, {"="," ",","})
    pos := [2]int{strconv.atoi(split[1]), strconv.atoi(split[2])}
    vel := [2]int{strconv.atoi(split[4]), strconv.atoi(split[5])}

    for _ in 0..<SECONDS {
      pos += vel
      if pos.x >= 0 {
        pos.x = pos.x%WIDTH
      } else {
        pos.x = (WIDTH + pos.x)%WIDTH
      }
      if pos.y >= 0 {
        pos.y = pos.y%HEIGHT
      } else {
        pos.y = (HEIGHT + pos.y)%HEIGHT
      }
    }

    if pos.x < WIDTH/2 && pos.y < HEIGHT/2 do quarters.x += 1
    else if pos.x < WIDTH/2 && pos.y > HEIGHT/2 do quarters.y += 1
    else if pos.x > WIDTH/2 && pos.y < HEIGHT/2 do quarters.z += 1
    else if pos.x > WIDTH/2 && pos.y > HEIGHT/2 do quarters.w += 1
  }

  fmt.println(quarters.x * quarters.y * quarters.z * quarters.w)
}

