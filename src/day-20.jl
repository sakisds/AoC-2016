### Day 20
## Firewall rules
## Author: Thanasis Georgiou
workspace()

# Read ruleset file
f = open("rules.txt")
input = readlines(f)
inputLen = length(input)
close(f)

# Organize array
rules = Array(Array{UInt32}, inputLen)
for i = 1:inputLen
  rules[i] = map(str -> parse(UInt32, str), split(input[i], '-'))
end

# Sort rules
sort!(rules, lt = (a, b) -> a[1] < b[1])

# Lower valid IP
validIp = 0x1
for (lower, upper) in rules
  if validIp >= lower && validIp <= upper
    validIp = upper + 1
  end
end
println("Lower valid address: $validIp")

# Count allowed IPs
blocked = 0
count = 0
for (lower, upper) in rules
  if lower - 1 > blocked
    count += lower - blocked - 1
  end
  blocked = max(blocked, upper)
end
count += typemax(UInt32) - blocked

println("Allowed IPs: $count")
