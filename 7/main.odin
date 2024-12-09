package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"


main :: proc() {
  data := os.read_entire_file_from_filename("7/input") or_else panic("no input file")
  lines := strings.split_lines(string(data)) or_else panic("allocator")

  total := 0
  for line in lines {
    if len(line) == 0 do continue
    line := line
    nums: [dynamic]int
    for num in strings.split_multi_iterate(&line, {":", " "}) {
      if len(num) == 0 do continue
      _ = append_elem(&nums, strconv.atoi(num)) or_else panic("converting")
    }
    if calibrate(nums[1], nums[0], nums[2:]) {
      total += nums[0]
    }
  }
  fmt.println(total)
}

calibrate :: proc(total, target: int, xs: []int) -> bool {
  if len(xs) == 0 {
    if total == target {
      return true
    } else {
      return false
    }
  }
  if total > target {
    return false
  }
  new_total := 0
  for o in operators {
    switch o {
      case .Multi:
        new_total = total*xs[0]
      case .Add:
        new_total = total+xs[0]
    }
    if ok := calibrate(new_total, target, xs[1:]); ok {
      return ok
    }
  }
  return false
}

Operator :: enum{
  Multi,
  Add,
}

operators := [?]Operator{
  .Multi,
  .Add,
}
