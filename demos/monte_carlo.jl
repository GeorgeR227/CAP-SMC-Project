using LinearAlgebra
using CAP_SMC_Project
using Random
using Combinatorics

nplayers = 12
players = auto_generate_playertags(nplayers)

println("There are $(factorial(12)) different permutations for $(nplayers) players")

a = 10
b = 5

payoff = Dict()
for coalition in powerset(players)
  val = a * length(coalition) + b * length(coalition)^2
  push!(payoff, coalition => val)
end

pred_shapley = a + b * length(players)
println("Predicted Shapley for all should be $(pred_shapley)")

maxval = a * nplayers + b

mc_shapley = monte_carlo_shapley_point(players, payoff, maxval)

shapley = fill(pred_shapley, nplayers)

@assert norm(shapley .- mc_shapley) < 1
println("Difference in known Shapley vs Monte Carlo Shapley is $(norm(shapley .- mc_shapley))")