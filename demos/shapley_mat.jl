using LinearAlgebra
using CAP_SMC_Project
using Random
using Combinatorics

nplayers = 8
players = auto_generate_playertags(nplayers)

# shapley_list = []

# ncoalitions = 2^(length(players))

# for idx in 2:ncoalitions
#   vec = zeros(ncoalitions)
#   vec[idx] = 1.0
#   payoff = Dict(zip(powerset(players), vec))
#   push!(shapley_list, shapley_point(payoff))
# end

# shapley_mat = hcat(shapley_list...)
# values = Float64[]
# shapley_mat * values[2:end]

payoff = Dict()
for coalition in powerset(players)
  val = 300 * length(coalition) + 50*length(coalition)^2
  push!(payoff, coalition => val)
end


rng = Xoshiro(1337)
shapley_values = Dict(zip(players, zeros(length(players))))

trials = factorial(nplayers) / 10

for i in 1:trials
  run_shapley_round!(shapley_values, payoff, players[randperm(rng, nplayers)])
end

for player in players
  println("$player: $(shapley_values[player] / trials)")
end
