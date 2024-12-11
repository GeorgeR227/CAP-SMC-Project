using CAP_SMC_Project
using Combinatorics
using LinearAlgebra

#Establishes Provinces
players = auto_generate_playertags(3)
provA = Province(players[1], 700)
provB = Province(players[2], 400)
provC = Province(players[3], 400)

#Establishes Conversion Rates Dict
ConversionRates = set_conversions(ntimes = 4, starting_price = 200)

#Establishes Prov names
country = [provA, provB, provC]
coalitions = powerset(country)
payoff = create_payoffs(coalitions, ConversionRates)
og_shapley = shapley_point(payoff)

# Generate the power set of provinces
tax = (700 + 400 + 400) * 0.05
country = redistribution(country, tax)
coalitions = powerset(country)

payoff = create_payoffs(coalitions, ConversionRates)

shapley = shapley_point(payoff)

let
  model, x = core(players, payoff)
  print(model)
end

shapley_feasible(players, payoff, shapley)

max_playerwise(players, payoff)

max_unfairness(players, payoff, shapley; start_values = [950, 245, 245])

fair_point = max_fairness(players, payoff, shapley);

equal_point = strongly_egalitarian_core(players, payoff);

println("Distance between the fair point and the equal point is $(norm(fair_point .- equal_point)).")

println("Distance between the original Shapley and the new Shapley is $(norm(og_shapley .- shapley)).")
