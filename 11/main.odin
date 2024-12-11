package main

import "core:os"
import "core:strings"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:math"

BLINKS :: 25

main :: proc() {
  data := os.read_entire_file_from_filename("11/input") or_else panic("no input")
  data_str := string(data[:len(data)-1])

  arr: [dynamic]int
  for str in strings.split_iterator(&data_str, " ") {
    append(&arr, strconv.atoi(str))
  }

  helper: [dynamic]int
  for blink in 0..<BLINKS {
    for num, i in arr {
      if num == 0 {
        append(&helper, 1)
      } else if digits := math.count_digits_of_base(num, 10); digits&1==0 {
        left, right := split_int(num, digits)
        append(&helper, left, right)
      } else {
        append(&helper, num * 2024)
      }
    }
    resize_dynamic_array(&arr, len(helper))
    copy_slice(arr[:], helper[:])
    clear_dynamic_array(&helper)
  }
  fmt.println(len(arr))
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
