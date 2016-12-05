### Day 5 - Problem 1 & 2
## How About a Nice Game of Chess
## Author: Thanasis Georgiou

using Nettle;

# Read input
input = "reyedfim"

# Password
password1 = Array{Char}(8)
password2 = Array{Char}(8)
fill!(password1, ' ')  # 8 Spaces
fill!(password2, ' ')  # 8 Spaces

# Test a couple of hashes
i = 0
while length(find(c -> c == ' ', password1)) != 0 || length(find(c -> c == ' ', password2)) != 0
    i += 1
    
    # Calculate hash
    md5 = hexdigest("md5", "$(input)$i")
    if md5[1:5] == "00000"
        # First password (in order)
        md5Char = md5[6]
        spaces = find(c -> c == ' ', password1)
        if length(spaces) != 0
            password1[spaces[1]] = md5Char
        end
        
        # Second password (with index)
        md5Index = parse(Int64, md5[6]) + 1
        md5Char = md5[7]
        
        if md5Index <= 8 && md5Index >= 1 && password2[md5Index] == ' '
            password2[md5Index] = md5Char
        end
    end
end
    
println("Password 1: $(password1)")
println("Password 2: $(password2)")