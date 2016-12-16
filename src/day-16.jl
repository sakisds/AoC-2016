### Day 16
## Dragon Checksum
## Author: Thanasis Georgiou

# Reset workspace to shut up warnings
workspace()

# Set disk length here
#diskLength = 272 # Problem 1
diskLength = 35651584 # Problem 2
input = collect("01111010110010011")

data = Array(Char, diskLength)
for i = 1:length(input)
  data[i] = input[i]
end
data[end] = 'e' # When this changes, the whole disk is overwritten

# Generate data
i = length(input)
while data[end] == 'e'
  currentData = data[i:-1:1] # Reverse current data
  map!(c -> c == '1'? '0' : '1', currentData)

  # Add separator
  data[i + 1] = '0'
  i += 2

  # Calculate length of new data
  newLen = length(currentData)
  if newLen > diskLength - i + 1
    newLen = diskLength - i + 1
  end

  # Add data to disk
  data[i:(i + newLen - 1)] = currentData[1:newLen]
  i += newLen - 1
end

# Calculate checksum
function calculateChecksum(checksum)
  # New checksum will have half the length of the original
  newChecksum = Array(Char, convert(Int, length(checksum) / 2))

  # Calculate checksum
  for i = 1:length(newChecksum)
    j = (i * 2) - 1
    newChecksum[i] = checksum[j] == checksum[j + 1]? '1' : '0'
  end

  # Return it back
  return newChecksum
end

checksum = calculateChecksum(data)
while iseven(length(checksum))
  checksum = calculateChecksum(checksum)
end

# Print result
println("Checksum: $(String(checksum))")
