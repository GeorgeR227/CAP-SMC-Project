using LinearAlgebra
using JuMP
using Ipopt
using Combinatorics
using Random

export core, load_payoffs, max_unfairness, max_fairness, max_playerwise, shapley_feasible

function core(players, payoff; shift = zeros(length(players)), solver = Ipopt.Optimizer, start_values = nothing)

  model = Model(solver)

  n_players = length(players)
  x = @variable(model, x[1:n_players])
  if !isnothing(start_values)
    set_start_value.(x, start_values)
  end
  player_map = Dict(zip(players, 1:n_players))

  for i in 1:(n_players-1)
    for coalition in combinations(players, i)
      coalition_players = map(x -> player_map[x], coalition)
      @constraint(model, sum(x[coalition_players]) >= payoff[coalition] - sum(shift[coalition_players]))
    end
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

function max_unfairness(players, payoff, shapley; start_values = nothing)
  if !isnothing(start_values)
    start_values = start_values .- shapley
  end

  model, x = core(players, payoff; shift = shapley, start_values = start_values)
  n_players = length(x)

  @objective(model, Max, sum(x[1:n_players].^2))

  optimize!(model);
  
  @assert is_solved_and_feasible(model)
  # println(solution_summary(model; verbose = true))

  println("Shapley outcome was: $(shapley)")
  println("Unfair outcome was: $(value.(x) .+ shapley)")
  println("Distance to farthest point from Shapley: $(sqrt(objective_value(model)))")
end

function max_fairness(players, payoff, shapley; start_values = nothing)
  if !isnothing(start_values)
    start_values = start_values .- shapley
  end

  model, x = core(players, payoff; shift = shapley, start_values = start_values)
  n_players = length(x)

  @objective(model, Min, sum(x[1:n_players].^2))

  optimize!(model);
  
  @assert is_solved_and_feasible(model)
  # println(solution_summary(model; verbose = true))

  println("Shapley outcome was: $(shapley)")
  println("Fair outcome was: $(value.(x) .+ shapley)")
  println("Distance to closest point from Shapley: $(sqrt(objective_value(model)))")
end


function max_playerwise(players, payoff)
  model, x = core(players, payoff)
  n_players = length(x)

  for player_id in 1:n_players
    @objective(model, Max, x[player_id])

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


  feasible = isempty(primal_feasibility_report(model, shapley_point))

  println("Shapley outcome was: $(shapley)")
  println("Is Shapley in the core: $(feasible)")
end


