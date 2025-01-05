package main

import "core:os"
import "core:slice"
import "core:math"
import "core:fmt"
import "core:time"


dirs: [4]int
data: []byte
low_score := max(int)
visited_score: []int

main :: proc() {
  data = os.read_entire_file_from_filename("16/input") or_else panic("no input")

  width := slice.linear_search(data, '\n') or_else panic("no width")
  width += 1
  reindeer := slice.linear_search(data, 'S') or_else panic("no reindeer")

  dirs = [4]int{
    -width,
    1,
    width,
    -1
  }

  visited_score = make([]int, len(data))
  for _, i in visited_score {
    visited_score[i] = max(int)
  }

  walk(reindeer, 0, 1000)
  walk(reindeer, 1, 0)
  walk(reindeer, 2, 1000)
  walk(reindeer, 3, 1000)
  fmt.println(low_score)
}

walk :: proc(loc, dir, score: int) {
  score := score + 1
  if score >= low_score do return
  next := loc + dirs[dir]
  if next < 0 || next >= len(data) do return
  if data[next] == '#' || visited_score[next] < score  do return
  if data[next] == 'E' {
    low_score = min(low_score, score)
    return
  }

  visited_score[next] = score

  walk(next, dir, score)
  score += 1000
  walk(next, (dir+1)%4, score)
  walk(next, (dir+3)%4, score)
}
