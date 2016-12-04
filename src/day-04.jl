### Day 4 - Problem 1 & 2
## Security Through Obscurity
## Author: Thanasis Georgiou

# Read input
f = open("rooms.txt")
input = readlines(f)
close(f)

# Verify room
function getRoomID(room::String)
    # Remove newline
    room = chomp(room)
    
    # Get checksum
    checksum = room[end - 5:end - 1]
    room = room[1:end - 7]
    
    # Get ID
    id = room[end - 2:end]
    room = room[1:end - 4]
    
    # Count each letter
    letters = Dict(map(x -> Pair(x, 0), unique(room)))
    foreach(x -> letters[x] += 1, room)
    delete!(letters, '-') # Drop dash
    
    # Sort most common letters first by how many times
    # they appear and then alphabetically by key
    comp(a, b) = begin
        if last(a) > last(b)
            return false
        elseif last(a) == last(b)
            return first(a) > first(b)
        else
            return true
        end
    end
    trueChecksumArr = sort(collect(letters), lt = comp, rev = true)
    trueChecksum = ""
    for kv in trueChecksumArr[1:5]
        trueChecksum = "$(trueChecksum)$(kv[1])"
    end
    
    # Verify checksum
    if trueChecksum == checksum
        # Grab ID
        roomId = parse(Int64, id)
        
        # Decrypt name
        name = map(room) do c
            if 'a' <= c <= 'z'
                (c - 'a' + roomId) % 26 + 'a'
            elseif c == '-'
                ' '
            end
        end
        
        if contains(name, "pole")
            println("North Pole Objects: $roomId")
        end
        
        # Return room ID
        return roomId
    else
        return 0
    end
end

# Get room IDs
result = sum(map(getRoomID, input))