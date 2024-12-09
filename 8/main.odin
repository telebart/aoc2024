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
  for b in data {
    if b == '\n' {
      append_elem(&data_matrix, slice.clone_to_dynamic(helper[:])[:])
      clear_dynamic_array(&helper)
      y += 1
      x = 0
      continue
    }
    append_elem(&helper, b)
    if b != '.' {
      temp := [2]int{x,y}
      if antennas[b] == nil {
        antennas[b] = [dynamic][2]int{temp}
      } else {
        append_elem(&antennas[b], [2]int{x,y})
      }
    }
    x += 1
  }

  count := 0
  for key, arr in antennas { for i in 0..<len(arr)-1 {
    window := arr[i:]
    for j in 1..<len(window) {
      dist_vec := window[0]-window[j]
      antitode_candidates := [2][2]int{window[0] + dist_vec, window[j] - dist_vec}
      for candidate in antitode_candidates {
        if candidate.y < 0 || candidate.y >= len(data_matrix) do continue
        if candidate.x < 0 || candidate.x >= len(data_matrix[0]) do continue
        if data_matrix[candidate.y][candidate.x] == '#' do continue
        data_matrix[candidate.y][candidate.x] = '#'
        count += 1
      }
    }
  }}
  fmt.println(count)
}
