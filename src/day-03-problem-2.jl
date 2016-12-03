### Day 3 - Problem 2
## Squares With Three Sides
## Author: Thanasis Georgiou

# Read triangle data
input = readdlm("triangles.csv")

# Start counting
count = 0

# For each triangle
for i = 0:1:size(input, 1)-1
    # Calculate vertical index of triangle
    # i + 1: 1, 2, 3, 4, 5, 6, 7, 8, 9...
    # v    : 1, 1, 1, 4, 4, 4, 7, 7, 7...
    v = i - (i % 3) + 1
    
    # Grab triangle (verI + 2 cells below)
    triangle = sort(
        view(input, v:v + 2, (i % 3) + 1)
    )
    
    # Check if it's a valid triangle
    count += triangle[1] + triangle[2] > triangle[3]
end

# Print result
println("Possible Triangles: $(count)")