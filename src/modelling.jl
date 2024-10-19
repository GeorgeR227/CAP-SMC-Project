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
  (model, x)
end

function load_payoffs(coalitions, values)
  payoff = Dict{Vector{Symbol}, Real}(zip(coalitions, values))
  push!(payoff, Symbol[] => 0)

  payoff
end

function max_unfairness(players, payoff, shapley)
  model, x = core(players, payoff; shift = shapley)
  n_players = length(x)

  @objective(model, Max, sum(x[1:n_players].^2))

  Random.seed!(1337)
  optimize!(model);
  
  @assert is_solved_and_feasible(model)
  # println(solution_summary(model; verbose = true))

  println("Shapley outcome was: $(shapley)")
  println("Unfair outcome was: $(value.(x) .+ shapley)")
  println("Distance to farthest point from Shapley: $(sqrt(objective_value(model)))")
end

function max_playerwise(model, variables)
  model, x = core(players, payoff)
  n_players = length(variables)

  for player_id in 1:n_players
    @objective(model, Max, x[player_id])

    Random.seed!(1337)
    optimize!(model)

    @assert is_solved_and_feasible(model)
    # println(solution_summary(model; verbose = true))
    println("Best outcome for player $player_id: $(value.(x))")
  end
end

function shapley_feasible(players, payoff, shapley)
  model, x = core(players, payoff)
  n_players = length(x)

  shapley_point = Dict(zip(x, shapley))


  Random.seed!(1337)
  feasible = isempty(primal_feasibility_report(model, shapley_point))

  println("Shapley outcome was: $(shapley)")
  println("Is Shapley in the core: $(feasible)")
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

let 
  model, x = core(players, payoff)
  print(model)
end

shapley_feasible(players, payoff, shapley)

max_playerwise(model, x)

max_unfairness(players, payoff, shapley)


