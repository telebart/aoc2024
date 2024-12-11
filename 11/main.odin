package main

import "core:os"
import "core:strings"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:math"

BLINKS :: 75

main :: proc() {
  data := os.read_entire_file_from_filename("11/input") or_else panic("no input")
  data_str := string(data[:len(data)-1])

  arr: [dynamic]int
  for str in strings.split_iterator(&data_str, " ") {
    append(&arr, strconv.atoi(str))
  }

  total := 0
  for x in arr {
    total += blink(x, BLINKS)
  }

  fmt.println(total)
}

memo := make(map[[2]int]int)

blink :: proc(num, depth: int) -> int {
  if depth == 0 do return 1
  val, ok := memo[{num,depth}]
  if ok do return val
  if num == 0 {
    memo[{num,depth}] = blink(1, depth-1)
    return memo[{num,depth}]
  } else if digits := math.count_digits_of_base(num, 10); digits&1==0 {
    left, right := split_int(num, digits)
    memo[{num,depth}] = blink(left, depth-1) + blink(right, depth-1)
    return memo[{num,depth}]
  } else {
    memo[{num,depth}] = blink(num * 2024, depth-1)
    return memo[{num,depth}]
  }
}

split_int :: proc(num, digits: int) -> (int, int) {
  left, right := 0, 0
  num := num
  digits := digits
  half := int(math.pow(10.0, f64(digits/2)))
  for i in 0..<digits {
    multiplier := int(math.pow(10.0, f64(i)))
    digit := num / multiplier % 10
    if i < digits/2 {
      right += digit * multiplier
    } else {
      left += digit * multiplier / half
    }
  }
  return left, right
}
