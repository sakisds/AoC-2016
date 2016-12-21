### Day 21
## Scrambled Letters and Hash
## Author: Thanasis Georgiou
workspace()
using Combinatorics

# Parse integer shortcut
# Plus one because strings in arrays in Julia start at 1
int(str::SubString)::Int = parse(Int, str) + 1

# Swap index
function swapIndex!(str::Array{Char}, i::Int, j::Int)
  tmp = str[i]
  str[i] = str[j]
  str[j]  = tmp
end

# Swap letter
function swapCharacter!(str::Array{Char}, a::Char, b::Char)
  indexOfa = find(c -> c == a, str)
  indexOfb = find(c -> c == b, str)

  str[indexOfa] = b
  str[indexOfb] = a
end

# Rotate
function rotate!(str::Array{Char}, shift::Int)
  str[1:end] = circshift(str, shift)[1:end]
end

# Rotate based on index
function rotateByIndex!(str::Array{Char}, letter::Char)
  # Determine how much to move
  index = findfirst(c -> c == letter, str)
  if index > 4
    index += 1
  end

  # Rotate
  str[1:end] = circshift(str, index)[1:end]
end

# Reverse part of the string
function reversePart!(str::Array{Char}, from::Int, to::Int)
  str[from:to] = str[to:-1:from]
end

# Move letter
function moveIndex!(str::Array{Char}, from::Int, to::Int)
  char = str[from]
  deleteat!(str, from)
  insert!(str, to, char)
end

# Scramble a password
function scramble!(password::Array{Char}, instructions::Array{String})
  for line in instructions
    instr = split(chomp(line), ' ')

    # Find out which function to call
    # Swaps
    if instr[1] == "swap"
      if instr[2] == "position"
        int1 = int(instr[3])
        int2 = int(instr[6])
        swapIndex!(password, int1, int2)
      else # == "letter"
        c1 = instr[3][1]
        c2 = instr[6][1]
        swapCharacter!(password, c1, c2)
      end
      continue
    end

    # Rotates
    if instr[1] == "rotate"
      if length(instr) == 4
        steps = int(instr[3]) - 1
        if instr[2] == "left"
          steps *= -1
        end
        rotate!(password, steps)
      else
        letter = instr[7][1]
        rotateByIndex!(password, letter)
      end
      continue
    end

    # Reverse
    if instr[1] == "reverse"
      from = int(instr[3])
      to = int(instr[5])
      reversePart!(password, from, to)
      continue
    end

    # Move
    if instr[1] == "move"
      from = int(instr[3])
      to = int(instr[6])
      moveIndex!(password, from, to)
      continue
    end
  end
end

# Load input
f = open("input.txt")
input = readlines(f)
close(f)

# Scramble password
password = collect("abcdefgh")
scramble!(password, input)
println("Scrambled password: $(String(password))")

# Bruteforce problem 2
target = collect("fbgdceah")
for combination in permutations(password)
  scrambled = copy(combination)
  scramble!(scrambled, input)
  if scrambled == target
    println("Original password: $(String(combination))")
    break
  end
end
