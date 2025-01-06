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
CORRUPTED_MEMORY :: -1

memory := [WIDTH][WIDTH]int{
  0..<WIDTH = UNVISITED
}
goal := [2]int{
  WIDTH-1,
  WIDTH-1,
}

dirs := [4][2]int{
  {1,0},
  {0,1},
  {-1,0},
  {0,-1},
}

main :: proc() {
  data := os.read_entire_file_from_filename("18/input") or_else panic("no input")
  data_lines := strings.split_lines(string(data[:len(data)-1]))

  memory[0][0] = 0
  for corrupted_memory in 0..<KILOBYTES {
    split := strings.split(data_lines[corrupted_memory], ",")
    x := strconv.atoi(split[0])
    y := strconv.atoi(split[1])
    memory[y][x] = CORRUPTED_MEMORY
  }

  i := KILOBYTES
  for {
    split := strings.split(data_lines[i], ",")
    x := strconv.atoi(split[0])
    y := strconv.atoi(split[1])
    last_corrupted_memory := [2]int{x,y}
    memory[y][x] = CORRUPTED_MEMORY
    memory_at_start := memory

    walk([2]int{0,0}, 0, 0)
    walk([2]int{0,0}, 1, 0)
    if !goal_found {
      fmt.println(last_corrupted_memory)
      break
    }
    memory = memory_at_start

    goal_found = false
    i += 1
  }
}

goal_found := false

walk :: proc(cur: [2]int, dir, steps: int) {
  if goal_found do return
  next := cur + dirs[dir]
  steps := steps + 1

  if next.x < 0 || next.x == WIDTH do return
  if next.y < 0 || next.y == WIDTH do return
  if memory[next.y][next.x] == CORRUPTED_MEMORY do return
  if next == goal {
    goal_found = true
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
