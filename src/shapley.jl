using Combinatorics

export calculate_shapely, format_shapley_values, shapley_point

shapley_point(payoffs::Dict) = format_shapley_values(calculate_shapely(payoffs))

# Function to calculate the Shapley values based on the provided coalition structure and payoffs
function calculate_shapely(coalition_payoffs::Dict)
    players = Set()
    for (coalition, _) in coalition_payoffs
        players = union(players, Set(coalition))  
    end

    player_list = collect(players)

    # Initialize Shapley values for each player
    shapley_values = Dict()
    for player in player_list
        shapley_values[player] = 0.0
    end

    n = length(player_list)

    # Iterate over all permutations of players
    for perm in permutations(player_list)
        current_value = 0
        current_coalition = []


        for (i, player) in enumerate(perm)
            prev_coalition_sorted = sort(current_coalition)  # Ensure consistent order
            prev_value = get(coalition_payoffs, prev_coalition_sorted, 0)

            push!(current_coalition, player)

            current_coalition_sorted = sort(current_coalition)
            current_value = get(coalition_payoffs, current_coalition_sorted, 0)

            marginal_contribution = current_value - prev_value
            shapley_values[player] += marginal_contribution
        end
    end

    for player in player_list
        shapley_values[player] = shapley_values[player] / factorial(n)
    end

    return shapley_values
end

# Gives Shapley values as a vector instead of a dictionary
# TODO: Decide how to format the Shapley point, either as a vector with players implied or as a dictionary
# from player to their own value
function format_shapley_values(shapley_values::Dict)
    player_list = sort(collect(keys(shapley_values)))
    formatted_shapley = [shapley_values[player] for player in player_list]
    return formatted_shapley
end
