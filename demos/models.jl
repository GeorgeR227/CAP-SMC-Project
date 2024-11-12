using CAP_SMC_Project
using Combinatorics
using LinearAlgebra

#Establishes Provinces
players = auto_generate_playertags(3)

total_budget = 1500.0

#Establishes Conversion Rates Dict
ConversionRates = calculate_budgets(3)

prov_budgets = calculate_budgets(players, total_budget)

println(prov_budgets)

# Generate the power set of provinces
coalitions = powerset(prov_budgets)

payoff = create_payoffs(coalitions, ConversionRates)
println(payoff)

shapley = shapley_point(payoff)

mc_shapley = monte_carlo_shapley_point(players, payoff, 600)

@assert norm(shapley - mc_shapley) < 1
@assert sum(mc_shapley) == payoff[players]

let
  model, x = core(players, payoff)
  print(model)
end

shapley_feasible(players, payoff, shapley)

max_playerwise(players, payoff)

max_unfairness(players, payoff, shapley)

fair_point = max_fairness(players, payoff, shapley);

equal_point = strongly_egalitarian_core(players, payoff);

println("Distance between the fair point and the equal point is $(norm(fair_point .- equal_point)).")