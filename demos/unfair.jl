using CAP_SMC_Project
using Combinatorics

players = auto_generate_playertags(2)

payoff = Dict(zip(powerset(players), [0, 5, 5, 20]))

shapley = shapley_point(payoff)

let
  model, x = core(players, payoff)
  print(model)
end

shapley_feasible(players, payoff, shapley)

max_playerwise(players, payoff)

max_unfairness(players, payoff, shapley; start_values = [10 + 0.0001, 10 - 0.0001])

fair_point = max_fairness(players, payoff, shapley)

equal_point = strongly_egalitarian_core(players, payoff)

println("Distance between the fair point and the equal point is $(norm(fair_point .- equal_point)).")