using LinearAlgebra
using JuMP
using Ipopt

function unfairness_solver(players, payoff, shapley; solver = Ipopt.Optimizer)

  model = Model(solver)

  n_players = length(players)
  @variable(model, x[1:n_players])
  player_map = Dict(zip(players, 1:n_players))

  for coalition in coalitions
    coalition_players = map(x -> player_map[x], coalition)
    @constraint(model, sum(x[coalition_players]) >= payoff[coalition] - sum(shapley[coalition_players]))
  end

  @constraint(model, sum(x[1:n_players]) == 0)

  @objective(model, Max, sum(x[1:n_players].^2))

  (x, model)
end

function load_payoffs(coalitions, values)
  payoff = Dict{Vector{Symbol}, Real}(zip(coalitions, values))
  push!(payoff, Symbol[] => 0)

  payoff
end

players = [:A, :B, :C]
coalitions = combinations(players)
values = [0,0,0, 600, 600, 0, 900]

payoff = load_payoffs(coalitions, values)

shapley_A = ((2 * 0) + 600 + 600 + (2 * 900)) / 6
shapley_B = ((2 * 0) + 600 + 0 + (2 * 300)) / 6
shapley_C = ((2 * 0) + 600 + 0 + (2 * 300)) / 6

shapley = [shapley_A, shapley_B, shapley_C]

x, model = unfairness_solver(players, payoff, shapley)

print(model)

optimize!(model)

@show is_solved_and_feasible(model)
solution_summary(model; verbose = true)

@show sqrt(objective_value(model))

value.(x) + shapley