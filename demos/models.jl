using CAP_SMC_Project
using Combinatorics

# TODO: Calculate Shapley from payoff

#Establishes Provinces
players = ["A", "B", "C"]
provA = Province("A", 700)
provB = Province("B",400)
provC = Province("C", 400)

Country = [provA, provB, provC]

#Establishes Conversion Rates Dict
ConversionRates = Dict{Int64, Int64}(900 => 600, 1500 => 900, 2000 => 1500)

# Generate the power set of provinces
coalitions = powerset(Country)

payoff = create_payoffs(coalitions, ConversionRates)

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
