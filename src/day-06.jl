### Day 6 - Problem 1 & 2
## Signals and Noise
## Author: Thanasis Georgiou

f = open("input.txt")
input = readlines(f)
close(f)

# Find length
packetLen = length(chomp(input[1]))

# Create an array of hashmaps
packet = Array(Dict{Char, Int}, packetLen)
map!(d -> Dict{Char, Int}(), packet)

# Read every line
for line in input
    arr = collect(chomp(line))
    for i = 1:length(arr)
        lastValue = get(packet[i], arr[i], -1)
        if lastValue == -1
            packet[i][arr[i]] = 1
        else
            packet[i][arr[i]] += 1
        end
    end
end

# Find max for each hashmap
sorter(a, b) = last(a) < last(b)

resultFalse = map(d -> sort(collect(d), lt = sorter, rev = true)[1][1], packet)
resultTrue = map(d -> sort(collect(d), lt = sorter, rev = false)[1][1], packet)

println("False packet: $(resultFalse)")
println("True packet: $(resultTrue)") 
