using CAP_SMC_Project
using Combinatorics

# TODO: Calculate Shapley from payoff
players = [:A, :B, :C]
n_players = length(players)
coalitions = combinations(players)
values = [0,0,0, 600, 600, 0, 900]

payoff = load_payoffs(coalitions, values)

shapley_A = ((2 * 0) + 600 + 600 + (2 * 900)) / 6
shapley_B = ((2 * 0) + 600 + 0 + (2 * 300)) / 6
shapley_C = ((2 * 0) + 600 + 0 + (2 * 300)) / 6

shapley = [shapley_A, shapley_B, shapley_C]

let
  model, x = core(players, payoff)
  print(model)
end

shapley_feasible(players, payoff, shapley)

max_playerwise(players, payoff)

max_unfairness(players, payoff, shapley)
