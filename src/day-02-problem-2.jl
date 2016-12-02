### Day 02 - Problem 2
## Bathroom Security
## Author: Thanasis Georgiou

# Load puzzle input
f = open("bathroom-code.txt")
input = readlines(f)
close(f)

# Pad buttons
pad = [
    ' ' ' ' '1' ' ' ' ';
    ' ' '2' '3' '4' ' ';
    '5' '6' '7' '8' '9';
    ' ' 'A' 'B' 'C' ' ';
    ' ' ' ' 'D' ' ' ' '
]

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
        # Create test finger
        testFinger = Point(finger.x, finger.y)
        
        # Move test finger
        if char == 'U'
            testFinger.x -= 1
        elseif char == 'D'
            testFinger.x += 1
        elseif char == 'L'
            testFinger.y -= 1
        elseif char == 'R'
            testFinger.y += 1
        end
        
        # Clamp within array bounds
        testFinger.x = clamp(testFinger.x, 1, 5)
        testFinger.y = clamp(testFinger.y, 1, 5)
            
        # Check if the finger landed on a button
        if pad[testFinger.x, testFinger.y] != ' '
            # Move the actual finger
            finger.x = testFinger.x
            finger.y = testFinger.y
        end
    end
    
    # Add key under finger to passcode
    PIN = "$(PIN)$(string(pad[finger.x, finger.y]))"
end

# Output result
println("PIN: $PIN")