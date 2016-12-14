### Day 14
## A Maze of Twisty Little Cubicles
## Author: Thanasis Georgiou

using Nettle

immutable PotentialKey
  hash::String
  fiveChar::String
  addedAt::Int
end

# Precalculate a couple of hashes
h = Hasher("md5")
salt = "qzyelonm"
hashes = Array(String, 1000000)

for i = 0:(1000000 - 1)
  update!(h, "$salt$i")
  hashes[i + 1] = hexdigest!(h)
end

# Find keys
keys = Array(PotentialKey, 64)
potentialKeys = Array(PotentialKey, 1000)

index = -1
keyIndex = 1
for hash in hashes
  index += 1

  # Look for same characters
  for i = 1:length(hash) - 2
    c = hash[i]
    if c == hash[i + 1] && c == hash[i + 2]
      fiveChar = "$c$c$c$c$c"

      if i < length(hash) - 4 && c == hash[i + 3] && c == hash[i + 4]
        for potentialKeyIndex = 1:length(potentialKeys)
          PotentialKey = potentialKeys[potentialKeyIndex]

          if potentialKey.fiveChar == fiveChar
            deleteat!(potentialKeys, potentialKeyIndex)
            if i - PotentialKey.addedAt < 1000
              keys[keyIndex] = key
              keyIndex += 1
            end
          end
        end
      end

      # Add current hash to hashmap
      push!(potentialKeys, PotentialKey(hash, fiveChar, index))
    end
  end

  if keyIndex > 64
    break
  end
end

render(keys[end])
