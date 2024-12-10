package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:bufio"

main :: proc() {
  f, ferr := os.open("9/input")
  if ferr != 0 {
    fmt.panicf("no input")
  }
  defer os.close(f)

  reader: bufio.Reader
  buffer: [1024]byte
  bufio.reader_init_with_buf(&reader, os.stream_from_handle(f), buffer[:])
  defer bufio.reader_destroy(&reader)

  data: [dynamic]Maybe(int)
  i := 0
  for {
    b, rerr := bufio.reader_read_byte(&reader)
    if rerr != nil {
      if rerr == .EOF do break
      fmt.panicf("reader read byte: %e", rerr)
    }
    if b == '\n' do break

    for _ in 0..<(int(b) - 48) {
      if i & 1 == 1 {
        append(&data, nil)
      } else {
        append(&data, i/2)
      }
    }
    i += 1
    }

    for x in data {
      if x == nil do fmt.print('.')
      else do fmt.print(x)
    }
    j := 0
    k := len(data)-1
    total := 0
    for {
      for data[j] != nil {
        total += j * data[j].?
        j += 1
      }
      for data[k] == nil {
        k -= 1
      }
      if j>k do break
      data[j], data[k] = data[k], data[j]
    }
    fmt.println()
    for x in data {
      if x == nil do fmt.print('.')
      else do fmt.print(x)
    }

    fmt.println()
    fmt.println(total)
}
