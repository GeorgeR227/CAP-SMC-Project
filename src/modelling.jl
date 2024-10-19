using LinearAlgebra
using JuMP
using Ipopt
using Combinatorics
using Random

function core(players, payoff; shift = zeros(length(players)), solver = Ipopt.Optimizer)

  model = Model(solver)

  n_players = length(players)
  @variable(model, x[1:n_players])
  player_map = Dict(zip(players, 1:n_players))

  for coalition in coalitions
    coalition_players = map(x -> player_map[x], coalition)
    @constraint(model, sum(x[coalition_players]) >= payoff[coalition] - sum(shift[coalition_players]))
  end

  @constraint(model, sum(x[1:n_players]) == payoff[players] - sum(shift))
  
  set_silent(model)
  println(model)

  (model, x)
end

function load_payoffs(coalitions, values)
  payoff = Dict{Vector{Symbol}, Real}(zip(coalitions, values))
  push!(payoff, Symbol[] => 0)

  payoff
end

function max_unfairness(model, variables, shapley)
  n_players = length(variables)

  @objective(model, Max, sum(x[1:n_players].^2))

  Random.seed!(1337)
  optimize!(model);
  
  @assert is_solved_and_feasible(model)
  # println(solution_summary(model; verbose = true))
  println("Distance to farthest point from Shapley: $(sqrt(objective_value(model)))")

  println("Shapley outcome was: $(shapley)")
  println("Unfair outcome was: $(value.(x) .+ shapley)")
end

function max_playerwise(model, variables, player_id)
  n_players = length(variables)

  @objective(model, Max, x[player_id].^2)

  Random.seed!(1337)
  optimize!(model)

  @assert is_solved_and_feasible(model)
  # println(solution_summary(model; verbose = true))

  println("Best outcome for player $player_id: $(value.(x))")
end

players = [:A, :B, :C]
n_players = length(players)
coalitions = combinations(players)
values = [0,0,0, 600, 600, 0, 900]

payoff = load_payoffs(coalitions, values)

shapley_A = ((2 * 0) + 600 + 600 + (2 * 900)) / 6
shapley_B = ((2 * 0) + 600 + 0 + (2 * 300)) / 6
shapley_C = ((2 * 0) + 600 + 0 + (2 * 300)) / 6

shapley = [shapley_A, shapley_B, shapley_C]

model, x = core(players, payoff; shift = shapley)
max_unfairness(model, x, shapley)

model, x = core(players, payoff)
for i in 1:n_players
  max_playerwise(model, x, i)
end


