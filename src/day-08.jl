### Day 8 - Problem 1
## Two-Factor Authentication
## Authors: Thanasis Georgiou, Marina Grigoropoulou

# Read input
f = open("input.txt")
input = readlines(f)
close(f)

# Screen
lcd = Array(Bool, 50, 6)

# Fill a rectangle at top left
function rect(w, h)
    for x = 1:w
        for y = 1:h
            lcd[x, y] = true
        end
    end
end

# Rotate a row by Δ
function rotateRow(y, Δ)
    lcd[1:50, y] = circshift(lcd[1:50, y], Δ)
end

# Rotate a column by Δ
function rotateColumn(x, Δ)
    lcd[x, 1:6] = circshift(lcd[x, 1:6], Δ)
end

# Parse input
for line in input
    str = split(line, ' ')

    # Determine command
    if str[1] == "rect"
        coords = split(str[2], 'x')
        w = parse(Int, coords[1])
        h = parse(Int, coords[2])
        rect(w, h)
    elseif str[1] == "rotate"
        Δ = parse(Int, str[end])
        l = parse(Int, str[3][3:end]) + 1

        if str[2] == "row"
            rotateRow(l, Δ)
        else
            rotateColumn(l, Δ)
        end
    end
end

# Count pixels
count = 0
for y = 1:6
    for x = 1:50
        if lcd[x, y] == true
            count += 1
            print("#")
        else
            print(" ")
        end
    end
    print("\n")
end

println("Count: $count")
