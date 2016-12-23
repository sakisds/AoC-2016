### Day 23
## Safe Cracking
## Author: Thanasis Georgiou
workspace()

# Convert anything to integer
int(any) = parse(Int, any)

# Type union of String and Int to use in instructions
IntOrString = Union{Int, String}

# Instruction struct
immutable Instruction
  opcode::String
  args::Array{IntOrString}
end

# A CPU with registers, a program counter and program ROM
type CPU
  gpreg::Dict{String, Int}
  pc::Int
  program::Array{Instruction}
end

# Supported opcodes
opcodes = Dict{String, Function}()

opcodes["cpy"] = function (cpu::CPU, args::Array{IntOrString})
  # Deconstruct args
  (from, to) = args

  # Value to copy
  value = isa(from, String)? cpu.gpreg[from] : from

  # Set target register
  cpu.gpreg[to] = value
end

opcodes["inc"] = function (cpu::CPU, args::Array{IntOrString})
  # Increment the register
  cpu.gpreg[args[1]] += 1
end

opcodes["dec"] = function (cpu::CPU, args::Array{IntOrString})
  # Decrement the register
  cpu.gpreg[args[1]] -= 1
end

opcodes["jnz"] = function (cpu::CPU, args::Array{IntOrString})
  # Deconstruct args
  (cond, jump) = args

  # Value to check
  value = isa(cond, String)? cpu.gpreg[cond] : cond

  # Jump if the value is not zero
  if value != 0
    jump = isa(jump, String)? cpu.gpreg[jump] : jump
    cpu.pc += jump
  end
end

opcodes["mul"] = function (cpu::CPU, args::Array{IntOrString})
  # Deconstruct array
  (times, with, to) = args

  # Parse args
  times = isa(times, String)? cpu.gpreg[times] : times
  with = isa(with, String)? cpu.gpreg[with] : with

  cpu.gpreg[to] += times * with
end

opcodes["tgl"] = function (cpu::CPU, args::Array{IntOrString})
  # Parse offset
  offset = isa(args[1], String)? cpu.gpreg[args[1]] : args[1]

  # Get instruction at offset
  if cpu.pc + offset > length(cpu.program)
    return
  end
  instr = cpu.program[cpu.pc + offset]

  # Switch instruction
  newOpcode = ""
  if length(instr.args) == 1
    if instr.opcode != "inc"
      newOpcode = "inc"
    else
      newOpcode = "dec"
    end
  elseif length(instr.args) == 2
    if instr.opcode == "jnz"
      newOpcode = "cpy"
    else
      newOpcode = "jnz"
    end
  end

  # Add back to program memory
  cpu.program[cpu.pc + offset] = Instruction(newOpcode, copy(instr.args))
end

opcodes["nop"] = function(cpu::CPU, args::Array{IntOrString})
end

# Go forward one clock cycle
function clock(cpu::CPU)::Bool
  # Get current instruction from program memory
  instr = cpu.program[cpu.pc]

  # Store program counter
  pc = cpu.pc

  # Execute instruction
  opcodes[instr.opcode](cpu, instr.args)

  # If the program counter didn't change by some instruction, we should move it to the next line in ROM
  if cpu.pc == pc
    cpu.pc += 1
  end

  # Check if there are more instructions to execute
  return cpu.pc <= length(cpu.program)
end

# Parse an instruction string into a struct
function parseInstruction(instr::String)::Instruction
  # Split at spaces
  instr = split(instr, ' ')
  argCount = length(instr) - 1

  # Arguments array
  args = Array(IntOrString, argCount)
  for i = 1:argCount
    arg = instr[i + 1]
    args[i] = get(tryparse(Int, arg), String(arg))
  end

  # Return struct
  return Instruction(instr[1], args)
end

function createCPU(rom::Array{String})::CPU
  # Initialize registers
  registers = Dict{String, Int}()
  registers["a"] = 0
  registers["b"] = 0
  registers["c"] = 0
  registers["d"] = 0

  # Create CPU
  return CPU(registers, 1, map(instr -> parseInstruction(instr), rom))
end

# Read input from file
f = open("safe-op.asm")
rom = map(line -> chomp(line), readlines(f))
close(f)

# Create CPU
cpu = createCPU(rom)

# Number of eggs in register a
cpu.gpreg["a"] = 12

# Execute program
i = 0
while clock(cpu)
  i += 1
end

# Print cpu state
println("Execution finished in $i clocks.")
