### Day 02 - Problem 1
## Bathroom Security
## Author: Thanasis Georgiou

# Load puzzle input
f = open("bathroom-code.txt")
input = readlines(f)
close(f)

# Pad buttons
pad = [1 2 3; 4 5 6; 7 8 9]

# Finger location
type Point
    x::Int
    y::Int
end

finger = Point(2,2)

# Bathroom PIN
PIN = ""

# Parse instructions
for line in input
    for char in line
        # Move finger
        if char == 'U'
            finger.x -= 1
        elseif char == 'D'
            finger.x += 1
        elseif char == 'L'
            finger.y -= 1
        elseif char == 'R'
            finger.y += 1
        end
            
        # Clamp to pad coordinates
        finger.x = clamp(finger.x, 1, 3)
        finger.y = clamp(finger.y, 1, 3)
    end
    
    # Add key under finger to passcode
    PIN = "$(PIN)$(string(pad[finger.x, finger.y]))"
end

# Output result
println("PIN: $PIN")