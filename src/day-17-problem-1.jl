### Day 17 - Problem 1
## Two Steps Forward
## Author: Thanasis Georgiou

workspace()
using Nettle

# Game state type, stores X/Y position and path followed to get there
immutable GameState
  x::Int
  y::Int
  path::Array{Char}
end

# Implement a simple queue type
type Queue
  arr::Array{GameState}
  index::Int
end
function Base.pop!(queue::Queue)::GameState
  state = queue.arr[queue.index]
  queue.index -= 1
  return state
end
function Base.append!(queue::Queue, state::GameState)::GameState
  queue.index += 1
  queue.arr[queue.index] = state
  return state
end
Base.getindex(queue::Queue, index::Int)::GameState = queue.arr[index]
Base.setindex!(queue::Queue, value::GameState, index::Int)::GameState = (queue.arr[index] = value)

# Input
input = "qtetzkpl"

# Characters that correspond to open doors
openChars = ['b', 'c', 'd', 'e', 'f']

# Store game states
queue = Queue(Array(GameState, 1000), 0)

# Add first position to queue to get started
append!(queue, GameState(1, 1, Array(Char, 0)))

# Create hasher
hasher = Hasher("md5")

while true
  # Grab current state
  state = pop!(queue)

  # If we are at the end break loop
  if state.x == state.y == 4
    println("Path: $(String(state.path))")
    break
  end

  # Calculate hash
  str = input * String(state.path)
  update!(hasher, str)
  hash = hexdigest!(hasher)[1:4]

  # For each open door add a new gamestate to the queue
  if in(hash[1], openChars) && state.y - 1 != 0 # Up
    newState = GameState(state.x, state.y - 1, Array(Char, length(state.path) + 1))
    newState.path[1:(end - 1)] = copy(state.path)
    newState.path[end] = 'U'
    append!(queue, newState)
  end
  if in(hash[2], openChars) && state.y + 1 != 5 # Down
    newState = GameState(state.x, state.y + 1, Array(Char, length(state.path) + 1))
    newState.path[1:(end - 1)] = copy(state.path)
    newState.path[end] = 'D'
    append!(queue, newState)
  end
  if in(hash[3], openChars) && state.x - 1 != 0 # Left
    newState = GameState(state.x - 1, state.y, Array(Char, length(state.path) + 1))
    newState.path[1:(end - 1)] = copy(state.path)
    newState.path[end] = 'L'
    append!(queue, newState)
  end
  if in(hash[4], openChars) && state.x + 1 != 5 # Right
    newState = GameState(state.x + 1, state.y, Array(Char, length(state.path) + 1))
    newState.path[1:(end - 1)] = copy(state.path)
    newState.path[end] = 'R'
    append!(queue, newState)
  end
end
