package main

import "core:os"
import "core:slice"
import "core:math"
import "core:fmt"
import "core:time"


dirs: [4]int
data: []byte
low_score := max(int)
low_score_paths: [dynamic][]int
visited_score: []int
best_path: []int

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

  visited: []int
  walk(reindeer, 0, 1000, visited)
  walk(reindeer, 1, 0, visited)
  walk(reindeer, 2, 1000, visited)
  walk(reindeer, 3, 1000, visited)

  best_path := make([]int, len(data))
  for path in low_score_paths {
    for p in path {
      best_path[p] += 1
    }
  }

  count := 2
  for p in best_path {
    if p > 0 do count += 1
  }
  fmt.println(count)
}

walk :: proc(loc, dir, score: int, path: []int) {
  score := score + 1
  if score > low_score do return
  next := loc + dirs[dir]
  if next < 0 || next >= len(data) do return
  if data[next] == '#'  do return
  if visited_score[next] < score do return

  if data[next] == 'E' {
    if score < low_score {
      clear_dynamic_array(&low_score_paths)
      low_score = score
    }
    path_copy := make([]int, len(path))
    copy(path_copy, path)
    append(&low_score_paths, path_copy)
    return
  }


  visited_score[loc] = score

  new_path := slice.clone_to_dynamic(path)
  defer delete_dynamic_array(new_path)
  append(&new_path, next)

  walk(next, dir, score, new_path[:])
  score += 1000
  walk(next, (dir+1)%4, score, new_path[:])
  walk(next, (dir+3)%4, score, new_path[:])
}
