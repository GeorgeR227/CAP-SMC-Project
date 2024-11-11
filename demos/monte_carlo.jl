using LinearAlgebra
using CAP_SMC_Project
using Random
using Combinatorics
using Plots

nplayers = 50
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

a = 10
b = 5

payoff = Dict()
for coalition in powerset(players)
  val = a * length(coalition) + b * length(coalition)^2
  push!(payoff, coalition => val)
end

println("Predicated Shapley for all should be $(a + b * length(players))")

maxval = a * nplayers + b

rng = Xoshiro(1337)
shapley_values = Dict(zip(players, zeros(length(players))))

p = 0.95
t = 1

trials = ceil(Int64, maxval^2 * nplayers * log(2 / (1 - 0.95^(1/nplayers))) / (2 * t^2))

for i in 1:trials
  if i % 1_000_000 == 0
    println("On trial $i")
  end
  run_shapley_round!(shapley_values, payoff, players[randperm(rng, nplayers)])
end

for player in players
  println("$player: $(shapley_values[player] / trials)")
end

marginal_points = Dict(player => [] for player in players)

for i in 1:100_000
  shapley_values = Dict(zip(players, zeros(length(players))))
  perm = players[randperm(rng, nplayers)]
  run_shapley_round!(shapley_values, payoff, perm)
  if shapley_values[first(players)] <= 0
    @show perm
    break
  end
  for player in keys(shapley_values)
    push!(marginal_points[player], shapley_values[player])
  end
end