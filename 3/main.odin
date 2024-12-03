package main

import "core:fmt"
import "core:io"
import "core:os"
import "core:bufio"
import "core:strings"
import "core:strconv"

main :: proc() {
  f, ferr := os.open("3/input")
  if ferr != 0 {
    fmt.panicf("no input")
  }
  defer os.close(f)

  reader: bufio.Reader
  buffer: [1024]byte
  bufio.reader_init_with_buf(&reader, os.stream_from_handle(f), buffer[:])
  defer bufio.reader_destroy(&reader)

  sum := 0
  for {
    multiplied, err := parse_instruction(&reader, 'm')
    if err != nil {
      fmt.panicf("error: %e", err)
    }
    val, ok := multiplied.?
    if !ok do break

    sum += val
  }
  fmt.println(sum)
}

dodont := true

parse_instruction :: proc(reader: ^bufio.Reader, expected: rune) -> (Maybe(int), io.Error) {
  r, _, err := bufio.reader_read_rune(reader)
  if err != nil {
    if err == .EOF {
      return nil, nil
    }
    return nil, err
  }

  for !dodont {
    do_val, err := parse_do_dont(reader, {'d'})
    if err == .EOF do return nil, nil
    if do_bool, ok := do_val.?; ok {
      dodont = do_bool
      return parse_instruction(reader, 'm')
    }
  }

  if r != expected {
    if r == 'd' {
      do_val, err := parse_do_dont(reader, {'o'})
      if err == .EOF do return nil, nil
        if do_bool, ok := do_val.?; ok {
          dodont = do_bool
        }
    }
    return parse_instruction(reader, 'm')
  }

  left := strings.builder_make()
  defer strings.builder_destroy(&left)
  right := strings.builder_make()
  defer strings.builder_destroy(&right)
  switch expected {
  case 'm':
    return parse_instruction(reader, 'u')
  case 'u':
    return parse_instruction(reader, 'l')
  case 'l':
    return parse_instruction(reader, '(')
  case '(':
    strings.builder_reset(&left)
    err := parse_number(reader, &left, true)
    switch v_err in err {
    case nil:
      strings.builder_reset(&right)
      err2 := parse_number(reader, &right, false)
      switch v_err in err2 {
      case nil:
        left_num := strconv.atoi(string(left.buf[:]))
        right_num := strconv.atoi(string(right.buf[:]))
        mult := left_num*right_num
        if left_num == 990 do fmt.println("returning mult", mult, left_num, right_num)
        return mult, nil
      case bool:
        return parse_instruction(reader, 'm')
      case io.Error:
        if v_err!= nil {
          if v_err == .EOF {
            return nil, nil
          }
          return nil, v_err
        }
      }
    case bool:
      return parse_instruction(reader, 'm')
    case io.Error:
      if err != nil {
        if err == .EOF {
          return nil, nil
        }
        return nil, v_err
      }
    }
  case ',':
  }

  return nil, .EOF
}

parse_do_dont :: proc(reader: ^bufio.Reader, runes: []rune, do_bool: bool = true) -> (Maybe(bool), io.Error) {
  r, _, err := bufio.reader_read_rune(reader)
  if err != nil {
    return nil, err
  }

  for expected in runes {
    if r != expected {
      continue
    }
    switch expected {
    case 'd':
      return parse_do_dont(reader, {'o'})
    case 'o':
      return parse_do_dont(reader, {'n', '('}, true)
    case '(':
      return parse_do_dont(reader, {')'}, do_bool)
    case 'n':
      return parse_do_dont(reader, {'\''})
    case '\'':
      return parse_do_dont(reader, {'t'})
    case 't':
      return parse_do_dont(reader, {'('}, false)
    case ')':
      return do_bool, nil
    }
  }

  return nil, nil
}

parse_number_error :: union {
  io.Error,
  bool,
}

parse_number :: proc(reader: ^bufio.Reader, curr: ^strings.Builder, left: bool) -> (parse_number_error) {
  r, _, err := bufio.reader_read_rune(reader)
  if err != nil {
    return err
  }

  switch r {
  case ',':
    if left do return nil

    err := bufio.reader_unread_rune(reader)
    if err != nil do return err

    return true
  case ')':
    if !left do return nil

    err := bufio.reader_unread_rune(reader)
    if err != nil do return err

    return true
  case '0'..='9':
    _, err := strings.write_rune(curr, r)
    if err != nil {
      return err
    }
    return parse_number(reader, curr, left)
  case:

    err := bufio.reader_unread_rune(reader)
    if err != nil do return err

    return true
  }
}

