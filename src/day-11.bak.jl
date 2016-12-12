### Day 11 - Problem 1
## Radioisotope Thermoelectric Generators
## Author: Thanasis Georgiou

using Combinatorics
using Base.isless
using Base.isequal

# Regex to find generators and microchips
generators(str) = map(x -> x[1:end - 10], matchall(r"(\w+) generator", str))
microchips(str) = map(x -> x[1:end - 11], matchall(r"(\w+)-compatible", str))

# Generator - Microchip pair
type GMPair
  generatorFloor::Int
  chipFloor::Int
end

function Base.isequal(a::GMPair, b::GMPair)::Bool
  return a.generatorFloor == b.generatorFloor && a.chipFloor == b.chipFloor
end

function Base.isless(a::GMPair, b::GMPair)::Bool
  if a.generatorFloor > b.generatorFloor
      return false
  elseif a.generatorFloor == b.generatorFloor
      return a.chipFloor > b.chipFloor
  else
      return true
  end
end

type GMPairContainer
  pairs::Array{GMPair}
  moves::Int
end

function Base.isequal(a::GMPairContainer, b::GMPairContainer)
  return a.pairs == b.pairs && a.moves == b.moves
end

# State
immutable State
  floors::Array{Array{String}}
  curFloor::Int
  moves::Int
end

# Unpack a state into it's components
unpack(state::State) = (state.floors, state.curFloor, state.moves)

# State for floorcount
function findPairs(state::State)::Array{GMPair}
  # Store in hashmap temporarily
  pairs = Dict{String}{GMPair}()

  # For each floor & item
  for i = 1:length(state.floors)
    floor = state.floors[i]
    for item in floor
      # Get element name
      name = item[2:end]

      # Create dict entry if it doesn't exist
      pair = get(pairs, name, 0)
      if pair == 0
        pair = GMPair(0, 0)
        pairs[name] = pair
      end

      # Fill in GMPair
      if item[1] == 'G'
        pair.generatorFloor = i
      else
        pair.chipFloor = i
      end
    end
  end

  # Flatten dictionary and return it
  return sort(map(x -> x[2], collect(pairs)))
end

# Create an empty floor plan
function createFloorPlan()
  floors = Array(Array{String}, 4)
  for i = 1:4
    floors[i] = Array(String, 0)
  end

  return floors
end

# Create all possible item pairs. An item can also be by itself
function createPairs(arr)
  out = map(x -> [x], arr)
  append!(out, collect(combinations(arr, 2)))
  return out
end

# Is this state valid?
function isStateValid(state::State)::Bool
  for floor in state.floors
    for item in floor
      if item[1] == 'C' && count(x -> x == "G$(item[2:end])", floor) == 0 && count(x -> x[1] == 'G', floor) > 0
        return false
      end
    end
  end

  return true
end

function possibleMoves(state::State)::Array{State}
  # Unpack state
  (floors, curFloor, moves) = unpack(state)

  # List of possible states
  possibleStates = Array(State, 0)

  # All item combinations to move
  items = createPairs(floors[curFloor])
  for pair in items
    # Move pair up
    if curFloor < 4
      # deepcopy floor plan & remove items
      newFloors = deepcopy(floors)
      foreach(x -> deleteat!(newFloors[curFloor], findfirst(newFloors[curFloor], x)), pair)

      # Add to upper floor
      append!(newFloors[curFloor + 1], pair)

      # Add to possible states
      push!(possibleStates, State(
        newFloors, curFloor + 1, moves + 1
      ))
    end

    # Move down
    emptyFloorsBelow = filter(floor -> length(floor) == 0, floors[1:curFloor])
    if curFloor > 1 && curFloor - 1 != length(emptyFloorsBelow)
      # deepcopy old plan & remove chip from current floor
      newFloors = deepcopy(floors)
      foreach(x -> deleteat!(newFloors[curFloor], findfirst(newFloors[curFloor], x)), pair)

      # Add to lower floor
      append!(newFloors[curFloor - 1], pair)

      # Add to possible states
      push!(possibleStates, State(
        newFloors, curFloor - 1, moves + 1
      ))
    end
  end

  # Return valid states only
  return filter(st -> isStateValid(st), possibleStates)
end

# Read input
f = open("input.txt")
instr = readlines(f)
close(f)

floorPlan = createFloorPlan()
# Parse instructions to create initial state
for i = 1:4
  # Remove floof
  line = chomp(instr[i])
  line = line[search(line, "contains")[end] + 2:end]

  # Split to objects
  gens = generators(line)
  chips = microchips(line)

  # Add to floor plan
  foreach(gen -> push!(floorPlan[i], "G" * gen), gens)
  foreach(chip -> push!(floorPlan[i], "C" * chip), chips)
end

#append!(floorPlan[1], ["GE", "CE", "GD", "CD"])

# Create states list and add initial state
initialState = State(floorPlan, 1, 0)
states = [initialState]

# Seen states
seenStates = Array(GMPairContainer, 0)

# Loop states
maxSteps = 0
c = 0
while true
  c += 1
  if c % 100 == 0
    println("Queue: $(length(states)), Known States: $(c - 1 ), Max moves: $maxSteps")
  end

  # Grab the first state from the list if it exists
  if length(states) == 0
    break
  end
  state = states[1]
  deleteat!(states, 1)
  push!(seenStates, GMPairContainer(findPairs(state), state.moves))

  if (state.moves > maxSteps)
    maxSteps = state.moves
  end

  if count(floor -> length(floor) == 0, state.floors[1:3]) == 3
    println("Finished, moves: $(state.moves)")
    break
  end

  moves = possibleMoves(state)
  filteredMoves = []
  for i = 1:length(moves)
    move = moves[i]
    movePairs = GMPairContainer(findPairs(move), state.moves)
    found = false

    for j = length(seenStates):-1:1
      if isequal(seenStates[j], movePairs)
        found = true
        break
      end
    end

    if found == false
      push!(filteredMoves, move)
    end
  end

  append!(states, filteredMoves)
end

info("Max moves: $maxSteps")
