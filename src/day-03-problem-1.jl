### Day 3 - Problem 1
## Squares With Three Sides
## Author: Thanasis Georgiou

# Read triangle data
input = readdlm("triangles.csv")

# For each row
count = 0
for i in 1:size(input, 1)
    # Get a row and sort it
    triangle = sort(view(input, i, :))
    
    # Is this row a valid triangle?
    count += triangle[1] + triangle[2] > triangle[3]
end

# Print result
println("Possible Triangles: $(count)")