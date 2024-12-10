package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:bufio"

Block :: struct {
  length: int,
  type: type,
}

type :: union {
  int,
}

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

  data: [dynamic]Block
  i := 0
  for {
    b, rerr := bufio.reader_read_byte(&reader)
    if rerr != nil {
      if rerr == .EOF do break
        fmt.panicf("reader read byte: %e", rerr)
    }
    if b == '\n' do break

      length := (int(b) - 48)
      if i & 1 == 1 {
        append(&data, Block{length, nil})
      } else {
        append(&data, Block{length, i/2})
      }

      i += 1
  }

  k := len(data)
  for {
    new_k, files_ok := search_files(data[:k]).?
    if !files_ok do break
      k = new_k

      length_file := data[new_k].length
      j, free_ok := search_free(data[:], length_file, k).?
      if !free_ok do continue
      length_free := data[j].length
      if j > k do continue
      diff := length_free - length_file
      if diff > 0 {
        data[j] = Block{ length_file, nil }
        new_data := make([dynamic]Block, 0, len(data)+1)
        for x in data[:j+1] {
          append(&new_data, x)
        }
        if diff == 0 do panic("what")
        append(&new_data, Block{diff, nil})
        for x in data[j+1:] {
          append(&new_data, x)
        }
        k += 1
        delete_dynamic_array(data)
        data = new_data
      }
      data[j], data[k] = data[k], data[j]
  }

  total := 0
  total_i := 0
  for block in data {
    if block.type == nil do total_i += block.length
    else {
      for _ in 0..<block.length {
        total += total_i * block.type.(int)
        total_i += 1
      }
    }
  }

  fmt.println(total)
}

search_free :: proc(arr: []Block, length, max_index: int) -> Maybe(int) {
  for x, i in arr {
    if i >= max_index do return nil
      if x.type == nil && x.length >= length {
        return i
      }
    }
    return nil
}

search_files :: proc(arr: []Block) -> Maybe(int) {
  #reverse for x, i in arr {
    if x.type != nil {
      return i
    }
  }
  return nil
}
