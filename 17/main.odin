package main

import "core:os"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:math"
import "core:fmt"


Registers :: struct {
  A, B, C: int
}

Ops :: enum {
  adv,
  bxl,
  bst,
  jnz,
  bxc,
  out,
  bdv,
  cdv,
}

main :: proc() {
  data := os.read_entire_file_from_filename("17/input") or_else panic("no input")
  data_lines := strings.split_lines(string(data))

  a := get_register(data_lines[0])

  program_split := strings.split(data_lines[4], " ")
  program: [dynamic]int
  for num in strings.split_iterator(&program_split[1], ",") {
    append(&program, strconv.atoi(num))
  }

  fmt.println(program)
  out: [dynamic]int
  power := 0
  for {
    clear(&out)
    run_program(power, program[:], &out)
    if slice.equal(program[:], out[:]) {
      break
    }

    if slice.equal(program[len(program)-len(out):], out[:]) {
      power *= 8
    } else {
      power += 1
    }
  }
  fmt.println(out, power)
}

run_program :: proc(a: int, program: []int, out: ^[dynamic]int) {
  reg := Registers{
    A = a,
  }

  instruction_pointer: int
  for {
    move := 2
    literal_operand := program[instruction_pointer + 1]
    combo_operand := literal_operand
    if combo_operand == 4 { combo_operand = reg.A
    } else if combo_operand == 5 { combo_operand = reg.B
    } else if combo_operand == 6 { combo_operand = reg.C
    } else if combo_operand == 7 do panic("invalid program")

    switch Ops(program[instruction_pointer]) {
    case .adv:
      reg.A = reg.A / int(math.pow2_f64(combo_operand))
    case .bxl:
      reg.B ~= literal_operand
    case .bst:
      reg.B = combo_operand % 8
    case .jnz:
      if reg.A != 0 {
        instruction_pointer = literal_operand
        move = 0
      }
    case .bxc:
      reg.B ~= reg.C
    case .out:
      append(out, combo_operand%8)
    case .bdv:
      reg.B = reg.A / int(math.pow2_f64(combo_operand))
    case .cdv:
      reg.C = reg.A / int(math.pow2_f64(combo_operand))
    }

    instruction_pointer += move
    if instruction_pointer >= len(program) do break
  }

}

get_register :: proc(line: string) -> int {
  split := strings.split(line, " ")
  return strconv.atoi(split[2])
}
