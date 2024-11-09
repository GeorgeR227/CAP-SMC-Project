using Combinatorics

export calculate_shapely, format_shapley_values, shapley_point, run_shapley_round!

shapley_point(payoffs::Dict) = format_shapley_values(calculate_shapely(payoffs))

# Function to calculate the Shapley values based on the provided coalition structure and payoffs
function calculate_shapely(payoffs::Dict)
    players = Set()
    for (coalition, _) in payoffs
        players = union(players, Set(coalition))
    end

    player_list = collect(players)
    nplayers = length(players)

    # Initialize Shapley values for each player
    shapley_values = Dict(zip(players, zeros(nplayers)))

    n = length(player_list)

    # Iterate over all permutations of players
    for perm in permutations(player_list)
      run_shapley_round!(shapley_values, payoffs, perm)
    end

    for player in player_list
        shapley_values[player] = shapley_values[player] / factorial(n)
    end

    return shapley_values
end

function run_shapley_round!(shapley_values, payoffs, perm)
  coalition = []

  for player in perm
    prev_value = get(payoffs, coalition, 0)

    sort!(push!(coalition, player))

    current_value = get(payoffs, coalition, 0)

    shapley_values[player] += current_value - prev_value
  end

  shapley_values
end


# Gives Shapley values as a vector instead of a dictionary
# TODO: Decide how to format the Shapley point, either as a vector with players implied or as a dictionary
# from player to their own value
function format_shapley_values(shapley_values::Dict)
    player_list = sort(collect(keys(shapley_values)))
    formatted_shapley = [shapley_values[player] for player in player_list]
    return formatted_shapley
end
