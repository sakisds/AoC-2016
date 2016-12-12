### Day 12 - Problem 1 & 2
## Leonardo's Monorail
## Author: Thanasis Georgiou

# A CPU with registers, a program counter and program ROM
type CPU
  gpreg::Dict{String, Int}
  pc::Int
  program::Array{String}
end

function cpy(cpu::CPU, from, to)
  # Check if origin is register or number
  from = get(tryparse(Int, from), String(from))

  # Value to copy
  value = isa(from, String)? cpu.gpreg[from] : from

  # Set target register
  cpu.gpreg[to] = value
end

function inc(cpu::CPU, reg)
  # Increment the register
  cpu.gpreg[reg] += 1
end

function dec(cpu::CPU, reg)
  # Decrement the register
  cpu.gpreg[reg] -= 1
end

function jnz(cpu::CPU, cond, jump)
  # Check if condition is a number or a register
  cond = get(tryparse(Int, cond), String(cond))

  # Value to check
  value = isa(cond, String)? cpu.gpreg[cond] : cond

  # Jump if the value is not zero
  if value != 0
    cpu.pc += parse(Int, jump)
  end
end

# Go forward one clock cycle
function clock(cpu::CPU)::Bool
  # Get current instruction from program memory
  instr = split(cpu.program[cpu.pc], ' ')

  # Store program counter
  pc = cpu.pc

  # Find out which instruction it is and execute it
  if instr[1] == "cpy"
    cpy(cpu, instr[2], instr[3])
  elseif instr[1] == "inc"
    inc(cpu, instr[2])
  elseif instr[1] == "dec"
    dec(cpu, instr[2])
  elseif instr[1] == "jnz"
    jnz(cpu, instr[2], instr[3])
  else
    error("Invalid opcode $(instr[1])! Halting...")
  end

  # If the program counter didn't change by some instruction, we should move it to the next line in ROM
  if cpu.pc == pc
    cpu.pc += 1
  end

  # Check if there are more instructions to execute
  return cpu.pc <= length(cpu.program)
end

function createCPU(rom::Array{String})::CPU
  # Initialize registers
  registers = Dict{String, Int}()
  registers["a"] = 0
  registers["b"] = 0
  registers["c"] = 0
  registers["d"] = 0

  # Create CPU
  return CPU(registers, 1, rom)
end

# Read input from file
f = open("cpu.asm")
rom = map(line -> chomp(line), readlines(f))
close(f)

# Create CPU
cpu = createCPU(rom)

# Problem 2: Initialize register c
cpu.gpreg["c"] = 1

# Execute program
i = 0
while clock(cpu)
  i += 1
end

# Print cpu state
println("Execution finished in $i clocks.")
render(cpu)
