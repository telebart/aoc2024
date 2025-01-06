package main

import "core:os"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:math"
import "core:fmt"
import "core:time"


KILOBYTES :: 1024
WIDTH :: 71
UNVISITED :: max(int)
WALL :: -1

memory := [WIDTH][WIDTH]int{
  0..<WIDTH = UNVISITED
}
goal := [2]int{
  WIDTH-1,
  WIDTH-1,
}

min_steps := max(int)
dirs := [4][2]int{
  {1,0},
  {0,1},
  {-1,0},
  {0,-1},
}

main :: proc() {
  data := os.read_entire_file_from_filename("18/input") or_else panic("no input")
  data_lines := strings.split_lines(string(data[:len(data)-1]))

  for corrupted_memory in 0..<KILOBYTES {
    split := strings.split(data_lines[corrupted_memory], ",")
    x := strconv.atoi(split[0])
    y := strconv.atoi(split[1])
    memory[y][x] = WALL
  }

  walk([2]int{0,0}, 0, 0)
  walk([2]int{0,0}, 1, 0)


  fmt.println(min_steps)
}

walk :: proc(cur: [2]int, dir, steps: int) {
  next := cur + dirs[dir]
  steps := steps + 1

  if next.x < 0 || next.x == WIDTH do return
  if next.y < 0 || next.y == WIDTH do return
  if memory[next.y][next.x] == -1 do return
  if next == goal {
    min_steps = min(min_steps, steps)
    return
  }

  if memory[next.y][next.x] <= steps do return
  memory[next.y][next.x] = steps

  left := (dir + 3) % 4
  right := (dir + 1) % 4
  walk(next, dir, steps)
  walk(next, left, steps)
  walk(next, right, steps)
}
