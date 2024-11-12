using CAP_SMC_Project
using Combinatorics
using LinearAlgebra

#Establishes Provinces
players = 
provA = Province("A", 700)
provB = Province("B",400)
provC = Province("C", 400)

#Establishes Prov names
players = auto_generate_playertags(3)
Country = [provA, provB, provC]

#Establishes Conversion Rates Dict
ConversionRates = set_conversions(4)

# Generate the power set of provinces
coalitions = powerset(Country)

payoff = create_payoffs(coalitions, ConversionRates)

shapley_A = ((2 * 0) + 600 + 600 + (2 * 900)) / 6
shapley_B = ((2 * 0) + 600 + 0 + (2 * 300)) / 6
shapley_C = ((2 * 0) + 600 + 0 + (2 * 300)) / 6

shapley = [shapley_A, shapley_B, shapley_C]

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
