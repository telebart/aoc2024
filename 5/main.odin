package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
  data := os.read_entire_file_from_filename("5/input") or_else panic("no input file")

  instruction_split := strings.split(string(data), "\n\n")

  rules_map: map[string][dynamic]string
  rules_lines := strings.split_lines(instruction_split[0])
  for line in rules_lines {
    split := strings.split(line, "|")
    if rules_map[split[0]] == nil {
      rules_map[split[0]] = [dynamic]string{split[1]}
    } else {
      append(&rules_map[split[0]], split[1])
    }
  }

  update_lines := strings.split_lines(instruction_split[1])
  sum := 0
  for line in update_lines {
    if len(line) == 0 do continue
    if val, ok := is_valid_line(line, rules_map).?; ok {
      sum += val
    }
  }
  fmt.println(sum)
}

is_valid_line :: proc(line: string, rules_map: map[string][dynamic]string) -> Maybe(int) {
  updates := strings.split(line, ",")
  defer delete(updates)

  indices, ok := is_invalid_line(updates, rules_map).?
  if !ok do return nil

  for {
    updates[indices.x], updates[indices.y] = updates[indices.y], updates[indices.x]
    indices, ok = is_invalid_line(updates, rules_map).?
    if !ok do break
  }

  val := strconv.atoi(updates[len(updates)/2])
  fmt.println("corrected line", val)
  return val
}

is_invalid_line :: proc(updates: []string, rules_map: map[string][dynamic]string) -> Maybe([2]int){
  for update, i in updates { for seen,j in updates[:i] {
    if slice.contains(rules_map[update][:], seen) do return [2]int{i, j}
  }}
  return nil
}
