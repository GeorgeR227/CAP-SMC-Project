using CAP_SMC_Project
using Combinatorics

#Establishes Provinces
players = auto_generate_playertags(3)

total_budget = 1500.0

#Establishes Conversion Rates Dict
ConversionRates = Dict{Int64, Int64}(900 => 600, 1500 => 900, 2000 => 1500)

prov_budgets = calculate_budgets(players, total_budget)

println(prov_budgets)

# Generate the power set of provinces
coalitions = powerset(prov_budgets)

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
