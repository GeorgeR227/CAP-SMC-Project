using CAP_SMC_Project
using Combinatorics
using LinearAlgebra

#Establishes Provinces
players = auto_generate_playertags(3)
provA = Province(players[1], 700)
provB = Province(players[2], 400)
provC = Province(players[3], 400)

#Establishes Prov names
country = [provA, provB, provC]

country = redistribution(country, 300)

#Establishes Conversion Rates Dict
ConversionRates = set_conversions(ntimes = 4, starting_price = 200)

# Generate the power set of provinces
coalitions = powerset(country)

payoff = create_payoffs(coalitions, ConversionRates)

shapley = shapley_point(payoff)

mc_shapley = monte_carlo_shapley_point(players, payoff, 490)

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
