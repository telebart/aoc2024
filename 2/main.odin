package main

import "core:os"
import "core:bufio"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:io"

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
  prev := strings.builder_make()
  defer strings.builder_destroy(&prev)
  next := strings.builder_make()
  defer strings.builder_destroy(&next)
  first := true
  plus: Maybe(bool)
  out: for {
    r, _, err  := bufio.reader_read_rune(&reader)
    if err != nil {
      if err != .EOF do fmt.panicf("error: %v", err)
      break
    }

    switch r {
    case ' ':
      if first {
        first = !first
        continue
      }

      if !is_safe(prev.buf[:], next.buf[:], &plus) {
        plus = nil
        strings.builder_reset(&prev)
        strings.builder_reset(&next)
        first = true

        for {
          r2, _, err  := bufio.reader_read_rune(&reader)
          if err != nil {
            if err == .EOF do break out
            fmt.panicf("error: %v", err)
          }

          if r2 == '\n' {
            break
          }
        }
      } else {
        strings.builder_reset(&prev)
        strings.write_bytes(&prev, next.buf[:])
        strings.builder_reset(&next)
      }

    case '\n':
      if is_safe(prev.buf[:], next.buf[:], &plus) {
        count_success += 1
      }

      first = true
      plus = nil
      strings.builder_reset(&prev)
      strings.builder_reset(&next)
    case:
      if first {
        strings.write_rune(&prev, r)
      } else {
        strings.write_rune(&next, r)
      }
    }
  }

  fmt.println(count_success)
}

is_safe :: proc(prev, next: []u8, plus: ^Maybe(bool)) -> bool {
  fst := strconv.atoi(string(prev))
  snd := strconv.atoi(string(next))

  diff := fst - snd
  if abs(diff) > 3 || diff == 0 do return false

  plus_val, ok := plus.?
  if !ok {
    plus^ = diff > 0
    return true
  }

  if (diff > 0) != plus_val do return false

  return true
}
