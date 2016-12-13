### Day 13 - Problem 1
## A Maze of Twisty Little Cubicles
## Author: Thanasis Georgiou

# Cell type
immutable Cell
  x::Int
  y::Int
  weight::Int
end

# Equality check for cells
function Base.isequal(a::Cell, b::Cell)::Bool
  return a.x == b.x && a.y == b.y
end

# Manhattan distance from cell to cell
function man_distance(a::Cell, b::Cell)::Int
  return abs(a.x - b.x) + abs(a.y - b.y)
end

# Manhattan distance from coords to cell
function man_distance(x::Int, y::Int, b::Cell)::Int
  return abs(x - b.x) + abs(y - b.y)
end

createHeuristicCell(x::Int, y::Int, target::Cell) = Cell(x, y, man_distance(x, y, target))

# -1 For wall, anything else is step count
floor = Array(Int, (50, 500))

# Create floor plan
for x = 0:49, y = 0:49
  magic = x * x + 3 * x + 2 * x * y + y + y * y
  magic += 1358
  bitCount = count(bit -> bit == '1', bits(magic))

 floor[x + 1, y + 1] = isodd(bitCount)? -1 : 0
end

# Find optimal path
target = Cell(31 + 1, 39 + 1, 0)
visited = Array(Cell, 0)
queue = Array(Cell, 0)
from = Dict{Cell, Cell}()
path = Array(Cell, 0)

# Add starting position to queue
push!(queue, createHeuristicCell(2, 2, target))

while length(queue) > 0
  # Sort queue
  sort!(queue, lt = (a, b) -> a.weight < b.weight)

  # Grab most promising cell
  cell = queue[1]
  push!(visited, cell)
  deleteat!(queue, 1)
  steps = floor[cell.x, cell.y]

  # Check if we are at the target
  if isequal(cell, target)
    println("Found target, counting steps...")
    # Count steps
    steps = 0
    while (cell = get(from, cell, -1)) != -1
      steps += 1
      push!(path, cell)
    end
    println("Steps: $steps")
    break
  end

  # Find neighbors
  # For each neighbor check it's a wall. If not, create a cell, push to queue
  # add to dictionary
  neighbors = [
    createHeuristicCell(cell.x + 1, cell.y, target),
    createHeuristicCell(cell.x - 1, cell.y, target),
    createHeuristicCell(cell.x, cell.y + 1, target),
    createHeuristicCell(cell.x, cell.y - 1, target),
  ]
  for neighbor in neighbors
    if floor[neighbor.x, neighbor.y] == false
      # Check if we have visited this before
      visitedIndex = findfirst(x -> isequal(x, neighbor), visited)
      if visitedIndex == 0
        push!(queue, neighbor)
        from[neighbor] = cell
        floor[neighbor.x, neighbor.y] = steps + 1
      else
        oldCell = visited[visitedIndex]
        if floor[oldCell.x, oldCell.y] > steps + 1
          deleteat!(visited, visitedIndex)
          from[neighbor] = cell
          floor[neighbor.x, neighbor.y] = steps + 1
        end
      end
    end
  end
end

println("Finished execution")
# Print map
for x = 1:40
  for y = 1:45
    if x == target.x && y == target.y
      print("x")
    elseif findfirst(cell -> cell.x == x && cell.y == y, path) == 0
      print(floor[x, y] == -1? "█" : " ")
    else
      print("o")
    end
  end
  println()
end
