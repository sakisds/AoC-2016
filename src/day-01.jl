### Day 01 - Problem 1
## No Time for a Taxicab
## Author: Thanasis Georgiou

# Puzzle input
input = "R4, R3, R5, L3, L5, R2, L2, R5, L2, R5, R5, R5, R1, R3, L2, L2, L1, R5, L3, R1, L2, R1, L3, L5, L1, R3, L4, R2, R4, L3, L1, R4, L4, R3, L5, L3, R188, R4, L1, R48, L5, R4, R71, R3, L2, R188, L3, R2, L3, R3, L5, L1, R1, L2, L4, L2, R5, L3, R3, R3, R4, L3, L4, R5, L4, L4, R3, R4, L4, R1, L3, L1, L1, R4, R1, L4, R1, L1, L3, R2, L2, R2, L1, R5, R3, R4, L5, R2, R5, L5, R1, R2, L1, L3, R3, R1, R3, L4, R4, L4, L1, R1, L2, L2, L4, R1, L3, R4, L2, R3, L1, L5, R4, R5, R2, R5, R1, R5, R1, R3, L3, L2, L2, L5, R2, L2, R5, R5, L2, R3, L5, R5, L2, R4, R2, L1, R3, L5, R3, R2, R5, L1, R3, L2, R2, R1"

# Unpack complex number
function unpack(num)
    return real(num), imag(num)
end

# Current position
pos = 0 + 0im
dir = 0 + 1im

# History
history = zeros(Int8, 2000, 2000) # Large enough array (TM)

# HQ Location
hqLoc = 0 + 0im
hqFound = false

# Parse the input
steps = split(input, ", ")

# For each command
for step in steps
    # Find direction
    dir = begin
        command = step[1]
        if command == 'L'
            dir * 1im
        else
            dir * (-1im)
        end
    end
    
    # Move blocks
    blockDelta = parse(Int64, step[2:end])
    for i=1:1:blockDelta
        pos += dir
        
        # Store history
        x, y = unpack(pos)
        history[1000 - x, 1000 - y] += 1
        
        # If we have been here before, this is the HQ
        if hqFound == false && history[1000 - x, 1000 - y] > 1
            hqLoc = pos
            hqFound = true
        end
    end
end

# Calculate distance
x, y = unpack(pos)
#println("Position: $(real(pos)), $(imag(pos))")
println("Position: $x, $y")
println("Distance to position: $(abs(x) + abs(y))")

hqX, hqY = unpack(hqLoc)
println("HQ Location: $hqX, $hqY")
println("HQ Distance: $(abs(hqX) + abs(hqY))")