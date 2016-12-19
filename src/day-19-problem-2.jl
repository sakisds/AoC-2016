### Day 19 - Problem 2
## An Elephant Named Joseph
## Author: Thanasis Georgiou
workspace()

# Input
elfCount = 3014387

# List item
type ListItem
  number::Int
  next::Int
end

# Create list
elves = map(i -> ListItem(i, i + 1), collect(1:elfCount))
elves[end].next = 1

# Find elfs
i = 1 # Start from beginning
while true
  # Delete next elf
  elf = elves[i]
  elf.next = elves[elf.next].next

  # Break if we are left with only one elf
  if elf.number == elves[elf.next].number
    break
  end

  i += 1
  if i > elfCount
    i = 1
  end
end

# Elf number
println("Last elf: $i")
