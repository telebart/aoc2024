package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"


main :: proc() {
  data := os.read_entire_file_from_filename("8/input") or_else panic("no input file")

  data_matrix: [dynamic][]byte
  antennas: map[byte][dynamic][2]int
  x, y := 0, 0
  helper: [dynamic]byte
  count := 0
  for b in data {
    if b == '\n' {
      append_elem(&data_matrix, slice.clone_to_dynamic(helper[:])[:])
      clear_dynamic_array(&helper)
      y += 1
      x = 0
      continue
    }
    if b != '.' {
      temp := [2]int{x,y}
      append_elem(&helper, '#')
      count += 1
      if antennas[b] == nil {
        antennas[b] = [dynamic][2]int{temp}
      } else {
        append_elem(&antennas[b], [2]int{x,y})
      }
    } else {
      append_elem(&helper, b)
    }
    x += 1
  }

  for key, arr in antennas { for i in 0..<len(arr)-1 {
    window := arr[i:]
    for j in 1..<len(window) {
      dist_vec := window[0]-window[j]
      next := window[0]
      for {
        next += dist_vec
        if next.y < 0 || next.y >= len(data_matrix) do break
        if next.x < 0 || next.x >= len(data_matrix[0]) do break
        if data_matrix[next.y][next.x] == '#' do continue
        data_matrix[next.y][next.x] = '#'
        count += 1
      }
      next = window[j]
      for {
        next -= dist_vec
        if next.y < 0 || next.y >= len(data_matrix) do break
        if next.x < 0 || next.x >= len(data_matrix[0]) do break
        if data_matrix[next.y][next.x] == '#' do continue
        data_matrix[next.y][next.x] = '#'
        count += 1
      }
    }
  }}
  fmt.println(count)
}
