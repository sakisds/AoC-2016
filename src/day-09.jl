### Day 9
## Explosives in Cyberspace
## Author: Thanasis Georgiou

function decompress(str, rec)
  output = 0
  i = 1
  while i <= length(str)
    # Find first marker
    markerStart = search(str, '(', i)

    # If there are no markers, add the rest of the length and skip
    if markerStart == 0
      output += length(str) - (i - 1)
      break
    else
      # Move to marker start
      output += markerStart - i
      i = markerStart

      # Parse marker
      markerEnd = search(str, ')', markerStart)
      marker = split(str[markerStart + 1:markerEnd - 1], 'x')

      len = parse(Int, marker[1])
      times = parse(Int, marker[2])

      # Extract accoarding to marker
      if rec == true
        output += times * decompress(str[markerEnd + 1:markerEnd + len], true)
      else
        output += times * len
      end

      # Move past this marker's influence
      i = markerEnd + len + 1
    end
  end

  return output
end

# Read file
f = open("input.txt")
input = chomp(readstring(f))
close(f)

# Print output
println("Length 1: $(decompress(input, false))")
println("Length 2: $(decompress(input, true))")
