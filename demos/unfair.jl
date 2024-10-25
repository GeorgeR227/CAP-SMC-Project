using CAP_SMC_Project
using Combinatorics

players = [:A, :B]

payoff = Dict(zip(powerset(players), [0, 5, 5, 20]))

shapley = [10.0, 10.0]

let
  model, x = core(players, payoff)
  print(model)
end

shapley_feasible(players, payoff, shapley)

max_playerwise(players, payoff)

max_unfairness(players, payoff, shapley; start_values = [10 + 0.0001, 10 - 0.0001])

max_fairness(players, payoff, shapley)