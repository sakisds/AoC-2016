### Day 10
## Balance Bots
## Author: Thanasis Georgiou

# Shortcut to convert strings to integers
int(str) = parse(Int, str)

# Regex to find targets and numbers
targets = r"to (\w+)"
numbers = r"(\d+)"

# Dictionary of bots
bots = Dict{Int}{Array{Int}}()
function getBot(id)
  bot = get(bots, id, -1)
  if bot == -1
    bot = Array(Int, 0)
    bots[id] = bot
  end

  return bot
end

# Dictionary of bins
outputBins = Dict{Int}{Array{Int}}()
function getBin(id)
  bin = get(outputBins, id, -1)
  if bin == -1
    bin = Array(Int, 0)
    outputBins[id] = bin
  end

  return bin
end

# A command is a string plus a boolean indicated if this command is
# executed.
type Command
  string::String
  executed::Bool
end

# Read input
f = open("input.txt")
commands = map(line -> Command(chomp(line), false), readlines(f))
close(f)

# Keep executing while there are unexecuted commands
while true
  filteredCommands = filter(cmd -> cmd.executed == false, commands)
  if length(filteredCommands) == 0
    break
  end

  for cmd in filteredCommands
    # Execute command
    if cmd.string[1:5] == "value"
      # Grab useful info
      (chipId, targetBot) = map(
        x -> int(x),
        matchall(numbers, cmd.string)
      )

      # Find target bot and give chip
      bot = getBot(targetBot)
      push!(bot, chipId)

      # Mark command as executed
      cmd.executed = true
      continue
    end

    # Grab useful info
    (lowType, highType) = matchall(targets, cmd.string)
    (source, lowTarget, highTarget) = map(
      x -> int(x),
      matchall(numbers, cmd.string)
    )

    # Get source bot
    sourceBot = getBot(source)
    if (length(sourceBot) < 2)
      continue
    end

    # Answer problem 1
    if minimum(sourceBot) == 17 && maximum(sourceBot) == 61
      println("Problem 1: $source")
    end

    # Pass to output
    if lowType == "to output"
      bin = getBin(lowTarget)
      push!(bin, minimum(sourceBot))
    else
      bot = getBot(lowTarget)
      push!(bot, minimum(sourceBot))
    end

    if highType == "to output"
      bin = getBin(highTarget)
      push!(bin, maximum(sourceBot))
    else
      bot = getBot(highTarget)
      push!(bot, maximum(sourceBot))
    end

    # Mark as executed
    cmd.executed = true
  end
end

product = outputBins[0][1] * outputBins[1][1] * outputBins[2][1]
println("Problem 2: $product")
