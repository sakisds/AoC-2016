### Day 15
## Timing is Everything
## Author: Thanasis Georgiou

# Hardcoded disks
disk1(t) = (t + 15) % 17 == 0
disk2(t) = (t + 2) % 3 == 0
disk3(t) = (t + 4) % 19 == 0
disk4(t) = (t + 2) % 13 == 0
disk5(t) = (t + 2) % 7 == 0
disk6(t) = (t + 0) % 5 == 0
disk7(t) = (t + 0) % 11 == 0

# Find time that works for problem 1
solution1 = 0
solution2 = 0
t = 0
while solution1 == 0 || solution2 == 0
  if solution1 == 0 && disk1(t + 1) && disk2(t + 2) && disk3(t + 3) && disk4(t + 4) && disk5(t + 5) && disk6(t + 6)
    solution1 = t
  end
  if solution2 == 0 && disk1(t + 1) && disk2(t + 2) && disk3(t + 3) && disk4(t + 4) && disk5(t + 5) && disk6(t + 6) && disk7(t + 7)
    solution2 = t
  end
  t += 1
end

println("Solutions: $solution1, $solution2")
