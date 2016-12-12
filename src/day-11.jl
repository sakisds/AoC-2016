### Day 11 - Problem 1
## Radioisotope Thermoelectric Generators
## Author: Thanasis Georgiou

using Combinatorics
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

# Create all possible item pairs. An item can also be by itself!
function createPairs(arr)
  out = map(x -> [x], arr)
  append!(out, collect(combinations(arr, 2)))
  return out
end

# State type
immutable State
  floors::Array{Array{String}}
  elevator::Int
  knownStates::Array{Array{GMPair}}
  parent::Union{State, Int}
end
unpack(state::State) = (state.floors, state.elevator, state.knownStates, state.parent)

function Base.isequal(a::State, b::State)::Bool
  return a.floors == b.floors && a.elevator == b.elevator
end

# Create an empty floor array
function createFloorArray()::Array{Array{String}}
  floors = Array(Array{String}, 4)
  for i = 1:4
    floors[i] = Array(String, 0)
  end

  return floors
end

# Is any chip fried by this state?
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

# Generate all possible moves from this state
function generateMoves(state::State)::Array{State}
  # Unpack state
  (floors, elevator, knownStates, parent) = unpack(state)

  # List of possible states
  possibleStates = Array(State, 0)

  # All item combinations to move
  items = createPairs(floors[elevator])
  for pair in items
    # Move pair up
    if elevator < 4
      # deepcopy floor plan & remove items
      newFloors = deepcopy(floors)
      foreach(x -> deleteat!(newFloors[elevator], findfirst(newFloors[elevator], x)), pair)

      # Add to upper floor
      append!(newFloors[elevator + 1], pair)

      # Add to possible states
      push!(possibleStates, State(
        newFloors, elevator + 1, Array(Array{GMPair}, 0), state
      ))
    end

    # Move down
    emptyFloorsBelow = filter(floor -> length(floor) == 0, floors[1:elevator])
    if elevator > 1 && elevator - 1 != length(emptyFloorsBelow)
      # deepcopy old plan & remove chip from current floor
      newFloors = deepcopy(floors)
      foreach(x -> deleteat!(newFloors[elevator], findfirst(newFloors[elevator], x)), pair)

      # Add to lower floor
      append!(newFloors[elevator - 1], pair)

      # Add to possible states
      push!(possibleStates, State(
        newFloors, elevator - 1, Array(Array{GMPair}, 0), state
      ))
    end
  end

  # Return valid states only
  return filter(st -> isStateValid(st), possibleStates)
end

function isStateKnown(state::State)::Bool
  pairs = findPairs(state)

  parent = state.parent
  while parent != 0
    if isequal(pairs, findPairs(parent))
      return true
    end

    for knownState in parent.knownStates
      if isequal(pairs, knownState)
        return true
      end
    end

    parent = parent.parent
  end

  return false
end

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

# Read input
f = open("input.txt")
instr = readlines(f)
close(f)

# Parse input to create the initial state
floorPlan = createFloorArray()
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

# Create state array and initial state
initialState = State(floorPlan, 1, Array(GMPair, 0), 0)
states = [initialState]
index = 1

# Find solution
while true
  # Get current state
  state = states[index]

  # Generate possible moves
  moves = generateMoves(state)
  filter!(move -> !isStateKnown(move), moves)

  # Add to known states
  append!(state.knownStates, map(move -> findPairs(move), moves))
  append!(states, moves)

  # Check if we found the solution
  if count(floor -> length(floor) == 0, state.floors[1:3]) == 3
    println("Finished somehow")
    break
  end

  # Increment index
  index += 1
  if index % 10 == 0
    println("Index -> $index")
  end
end
