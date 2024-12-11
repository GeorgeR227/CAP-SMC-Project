using LinearAlgebra
using JuMP
using Ipopt
using Combinatorics
using Random

export core, max_unfairness, max_fairness, max_playerwise, shapley_feasible, strongly_egalitarian_core

"""
    core(players, payoff; shift = zeros(length(players)), solver = Ipopt.Optimizer, start_values = nothing)

Generates a model in JuMP representing the core as a collection of linear inequalities.
"""
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

"""
    max_unfairness(players, payoff, shapley; start_values = nothing)

Attempts to discover the point of maximum unfairness as defined by the point furthest from the 
Shapley and yet still in the core. Since this is maximizing a convex function over a convex set,
essentially concave programming, this only returns a local maximum. 
"""
function max_unfairness(players, payoff, shapley; start_values = nothing)
  if !isnothing(start_values)
    start_values = start_values .- shapley
  end

  model, x = core(players, payoff; shift = shapley, start_values = start_values)
  n_players = length(x)

  @objective(model, Max, sum(x.^2))

  optimize!(model);
  
  @assert is_solved_and_feasible(model)
  # println(solution_summary(model; verbose = true))

  println("Shapley outcome was: $(shapley)")
  println("Unfair outcome was: $(value.(x) .+ shapley)")
  println("Distance to farthest point from Shapley: $(sqrt(objective_value(model)))")

  value.(x) .+ shapley
end

"""
    max_fairness(players, payoff, shapley; start_values = nothing)

Attempts to discover the point of maximum fairness as defined by the point closest from the 
Shapley and yet still in the core. This is accomplished through convex programming.
"""
function max_fairness(players, payoff, shapley; start_values = nothing)
  if !isnothing(start_values)
    start_values = start_values .- shapley
  end

  model, x = core(players, payoff; shift = shapley, start_values = start_values)
  n_players = length(x)

  @objective(model, Min, sum(x.^2))

  optimize!(model);
  
  @assert is_solved_and_feasible(model)
  # println(solution_summary(model; verbose = true))

  println("Shapley outcome was: $(shapley)")
  println("Fair outcome was: $(value.(x) .+ shapley)")
  println("Distance to closest point from Shapley: $(sqrt(objective_value(model)))")

  value.(x) .+ shapley
end


"""
    max_playerwise(players, payoff)

Attempts to discover the outcome of maximum benefit, meaning the highest payoff, for a particular
player with that outcome still in the core. This is accomplished through linear programming.
"""
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

"""
    shapley_feasible(players, payoff, shapley)

Runs a feasibility check to determine if the Shapley point is located in the core.
"""
function shapley_feasible(players, payoff, shapley)
  model, x = core(players, payoff)
  n_players = length(x)

  shapley_point = Dict(zip(x, shapley))


  feasible = isempty(primal_feasibility_report(model, shapley_point))

  println("Shapley outcome was: $(shapley)")
  println("Is Shapley in the core: $(feasible)")
end

"""
    strongly_egalitarian_core(players, payoff)

Finds the Strongly Egalitarian Core which is defined as the outcome of minimal Euclidean
norm in the core. This generalizes the "equal" outcome where all players receive the same
payoff.
"""
function strongly_egalitarian_core(players, payoff)
  model, x = core(players, payoff)
  n_players = length(x)

  @objective(model, Min, sum(x.^2))

  optimize!(model)

  @assert is_solved_and_feasible(model)

  println("The strongly egalitarian core is the point: $(value.(x))")
  
  value.(x)
end
