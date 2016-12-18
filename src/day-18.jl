### Day 18
## Like a Rogue
## Author: Thanasis Georgiou
workspace()

# If the neighbors of a tile match any of these then it's trapped
trapScenarios = [
  ['^', '^', '.'],
  ['.', '^', '^'],
  ['^', '.', '.'],
  ['.', '.', '^'],
]

# Check if the neighbors of a tile match any of the trap scenarios
function isTrap(neighbors::Array{Char})::Bool
  for trapScenario in trapScenarios
    if neighbors == trapScenario
      return true
    end
  end
  return false
end

# Puzzle input
input = "......^.^^.....^^^^^^^^^...^.^..^^.^^^..^.^..^.^^^.^^^^..^^.^.^.....^^^^^..^..^^^..^^.^.^..^^..^^^.."
rowLength = length(input)
#rowCount = 40
rowCount = 400000

# Floors plan
floorPlan = Array(Array{Char}, rowCount)
floorPlan[1] = collect(input)
row = 2

# Keep count of how many safe tiles we have found
safeTiles = count(t -> t == '.', floorPlan[1])

# Calculate floor plan
while row <= rowCount
  # Add new row to plan
  floorPlan[row] = Array(Char, rowLength)

  # Calculate first tile
  neighbors = Array(Char, 3)
  neighbors[1] = '.'
  neighbors[2:3] = floorPlan[row - 1][1:2]
  floorPlan[row][1] = isTrap(neighbors)? '^' : '.'
  safeTiles += floorPlan[row][1] == '.'? 1 : 0

  # Calculate last tile
  neighbors[3] = '.'
  neighbors[1:2] = floorPlan[row - 1][(end - 1):end]
  floorPlan[row][end] = isTrap(neighbors)? '^' : '.'
  safeTiles += floorPlan[row][end] == '.'? 1 : 0

  # Calculate the rest
  for i = 2:(rowLength - 1)
    neighbors = floorPlan[row - 1][(i - 1):(i + 1)]
    floorPlan[row][i] = isTrap(neighbors)? '^' : '.'
    safeTiles += floorPlan[row][i] == '.'? 1 : 0
  end

  # Move to next row
  row += 1
end

println("Amount of safe tiles: $safeTiles")
