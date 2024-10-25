using CAP_SMC_Project
using Combinatorics

# TODO: Calculate Shapley from payoff

#Establishes Provinces
players = ["A", "B", "C"]

total_budget = 1500.0

#Establishes Conversion Rates Dict
ConversionRates = Dict{Int64, Int64}(900 => 600, 1500 => 900, 2000 => 1500)

println(calculate_budgets(players, total_budget))

# Generate the power set of provinces
coalitions = powerset(calculate_budgets(players, total_budget))

payoff = create_payoffs(coalitions, ConversionRates)
println(payoff)

shapley = shapley_point(payoff)

let
  model, x = core(players, payoff)
  print(model)
end

shapley_feasible(players, payoff, shapley)

max_playerwise(players, payoff)

max_unfairness(players, payoff, shapley)

max_fairness(players, payoff, shapley)