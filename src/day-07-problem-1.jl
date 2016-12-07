### Day 7 - Problem 1
## Internet Protocol Version 7
## Authors: Thanasis Georgiou, Marina Grigoropoulou

# Looks for an ABBA identifier
function findABBA(str)
    len = length(str)
    if len < 4
        return false
    end
    
    for i = 2:len - 2
        if str[i] == str[i + 1] && str[i - 1] == str[i + 2] && str[i] != str[i - 1]
            return true
        end
    end
    return false
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
    
    # Find ABBA identifiers in brackets
    abbaIn = findABBA(inBracket)
    abbaOut = findABBA(outBracket)
    
    # If it's valid increment counter
    if abbaIn == false && abbaOut == true
        count += 1
    end
end

println("Valid IPs: $count")
