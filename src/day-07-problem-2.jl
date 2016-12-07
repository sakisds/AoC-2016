### Day 7 - Problem 2
## Internet Protocol Version 7
## Authors: Thanasis Georgiou, Marina Grigoropoulou

# Looks for an ABA identifier. Compatible with BAB
function findABAs(str)
    foundABAs = []
    
    len = length(str)    
    if len >= 3
        for i = 1:len - 2
            if str[i] == str[i + 2]
                push!(foundABAs, str[i:i + 2])
            end
        end
    end
    
    return foundABAs
end

# Are the ABA and BAB identifiers a pair
function isPair(aba, bab)
    return collect(aba) == [bab[2], bab[1], bab[2]]
end

# Read input
f = open("input.txt")
input = readlines(f)
close(f)

# How many support TLS
count = 0

# For each IP
for ip in input
    # Split in string that are contained in brackets
    # and ones that are not
    bracketArr = matchall(r"\[\w*\]", ip)
    map!(str -> str[2:end-1], bracketArr)
    
    inBracket = join(bracketArr, '-')
    outBracket = replace(ip, r"\[\w*\]", "-")
    
    # Find ABAs and BABs
    inABAs = findABAs(inBracket)
    outABAs = findABAs(outBracket)
    
    # Check if any pair is valid
    found = false
    for i = 1:length(inABAs)
        for j = 1:length(outABAs)
            if isPair(inABAs[i], outABAs[j])
                found = true
                break
            end
        end
        
        if found
            break
        end
    end
    
    # This IP was valid
    if found
        count += 1
    end
end

println("Valid IPs: $count")
