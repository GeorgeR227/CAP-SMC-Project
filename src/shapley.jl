using Combinatorics

export shapley_point, monte_carlo_shapley_point

shapley_point(payoffs::Dict) = format_shapley_values(calculate_shapely(payoffs))

"""
    monte_carlo_shapley_point(players, payoff::Dict, max::Real; p = 0.95, t = 1, rng = Xoshiro(1337))

Runs a Monte Carlo simulation based on the Type 0 algorithm provided in https://www.rand.org/pubs/research_memoranda/RM2651.html
although the given algorithm assumes a bionomial distribution while ours is unknown yet almost surely bounded.
We thus use a Hoeffding bound to determine the number of trials needed. 
"""
function monte_carlo_shapley_point(players, payoff::Dict, max::Real; p = 0.95, t = 1, rng = Xoshiro(1337))
  nplayers = length(players)

  # Calculated using a Hoeffding bound
  trials = ceil(Int64, max^2 * nplayers * log(2 / (1 - p^(1/nplayers))) / (2 * t^2))
  
  println("Running Monte Carlo with $trials trials...")

  shapley_values = Dict(zip(players, zeros(length(players))))

  for i in 1:trials
    if i % 500_000 == 0
      println("On trial $i...")
    end
    run_shapley_round!(shapley_values, payoff, players[randperm(rng, nplayers)])
  end

  return [(shapley_values[player] / trials) for player in players]
end

"""
    calculate_shapely(payoffs::Dict)

Computes the Shapley value exactly as per its definition, i.e. the average of all the marginal
contributions among all permutations of players.
"""
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

  val = 0
  next_val = 0

  for player in perm
    coalition = sort(push!(coalition, player))
    next_val = get(payoffs, coalition, 0)

    shapley_values[player] += next_val - val
    val = next_val
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
