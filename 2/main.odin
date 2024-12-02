package main

import "core:os"
import "core:bufio"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
  f, ferr := os.open("2/input")
  if ferr != 0 {
    fmt.panicf("no input")
  }
  defer os.close(f)

  reader: bufio.Reader
  buffer: [1024]byte
  bufio.reader_init_with_buf(&reader, os.stream_from_handle(f), buffer[:])
  defer bufio.reader_destroy(&reader)

  count_success := 0
  for {
    line, err := bufio.reader_read_string(&reader, '\n')
    if err != nil {
      break
    }
    defer delete(line)
    line = strings.trim_right(line, "\n")

    split := strings.split(line, " ")
    if is_safe(split) do count_success += 1
  }

  fmt.println(count_success)
}

is_safe :: proc(original: []string) -> bool {
    compare := slice.clone_to_dynamic(original[:])
    defer delete_dynamic_array(compare)

    fail_index := check_safe(compare[:])
    if fail_index == -1 do return true

    compare = slice.clone_to_dynamic(original[:])
    ordered_remove(&compare, fail_index)
    success := check_safe(compare[:])
    if success == -1 do return true

    compare = slice.clone_to_dynamic(original[:])
    ordered_remove(&compare, fail_index+1)
    success = check_safe(compare[:])
    if success == -1 do return true

    if fail_index - 1 == 0 {
      compare = slice.clone_to_dynamic(original[:])
      ordered_remove(&compare, 0)
      success = check_safe(compare[:])
      if success == -1 do return true
    }

    fmt.println("failed", original, fail_index)
    return false
}

check_safe :: proc(compare: []string) -> int {
  plus: bool
  for i in 0..<len(compare)-1 {
    fst := strconv.atoi(compare[i])
    snd := strconv.atoi(compare[i+1])
    diff := fst - snd

    if i == 0 {
      plus = diff > 0
    }

    if abs(diff) > 3|| diff == 0 || (diff > 0) != plus {
      return i
    }
  }
  return -1
}
