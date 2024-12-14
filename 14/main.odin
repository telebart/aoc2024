package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:time"

WIDTH :: 101
HEIGHT :: 103

main :: proc() {
  data := os.read_entire_file_from_filename("14/input") or_else panic("no input")

  lines := strings.split_lines(string(data[:len(data)-1]))


  quarters: [4]int
  guards: [dynamic]Guard
  for line in lines {
    split := strings.split_multi(line, {"="," ",","})
    pos := [2]int{strconv.atoi(split[1]), strconv.atoi(split[2])}
    vel := [2]int{strconv.atoi(split[4]), strconv.atoi(split[5])}
    append(&guards, Guard{pos, vel})
  }

  s, next: int
  for {
    s += 1
    for &g in guards{
      g.pos += g.vel
      if g.pos.x >= 0 {
        g.pos.x = g.pos.x%WIDTH
      } else {
        g.pos.x = (WIDTH + g.pos.x)%WIDTH
      }
      if g.pos.y >= 0 {
        g.pos.y = g.pos.y%HEIGHT
      } else {
        g.pos.y = (HEIGHT + g.pos.y)%HEIGHT
      }
    }
    //if {
      fmt.print("\033[2J")
      fmt.println("----", s , "-----")
      print_map(guards[:])
      time.sleep(time.Millisecond * 200)
    //}
  }

  for g in guards {
    if g.pos.x < WIDTH/2 && g.pos.y < HEIGHT/2 do quarters.x += 1
    else if g.pos.x < WIDTH/2 && g.pos.y > HEIGHT/2 do quarters.y += 1
    else if g.pos.x > WIDTH/2 && g.pos.y < HEIGHT/2 do quarters.z += 1
    else if g.pos.x > WIDTH/2 && g.pos.y > HEIGHT/2 do quarters.w += 1
  }

  fmt.println(quarters)
  fmt.println(quarters.x * quarters.y * quarters.z * quarters.w)
}

Guard :: struct{
  pos: [2]int,
  vel: [2]int,
}

guards_contains_pos :: proc(guards: []Guard, lookup: [2]int) -> bool {
  for g in guards {
    if g.pos == lookup do return true
  }
  return false
}

print_map :: proc(guards: []Guard) {
  for y in 0..<HEIGHT {
    for x in 0..<WIDTH {
      if guards_contains_pos(guards, {x,y}) {
        fmt.print("■")
      } else {
        fmt.print(" ")
      }
    }
    fmt.println()
  }
}
