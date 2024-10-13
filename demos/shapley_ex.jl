using LinearAlgebra
using JuMP
using Ipopt

# This is based on the example included in the first slides

model = Model(Ipopt.Optimizer)

@variable(model, x[1:3] >= 0)

@constraint(model, x[1] + x[2] >= 600)
@constraint(model, x[1] + x[3] >= 600)
@constraint(model, x[2] + x[3] >= 0)

@constraint(model, x[1] + x[2] + x[3] == 900)

Shapley_A = ((2 * 0) + 600 + 600 + (2 * 900)) / 6
Shapley_B = ((2 * 0) + 600 + 0 + (2 * 300)) / 6
Shapley_C = ((2 * 0) + 600 + 0 + (2 * 300)) / 6

Shapley = [Shapley_A, Shapley_B, Shapley_C]

@assert sum(Shapley) == 900

sh_distance(x...) = (x[1] - Shapley_A)^2 + (x[2] - Shapley_B)^2 + (x[3] - Shapley_C)^2
function ∇sh_distance(g::AbstractVector, x...)
  g[1] = 2*x[1]-1000
  g[2] = 2*x[2]-400
  g[3] = 2*x[3]-400
end
function ∇²sh_distance(H::AbstractMatrix, x...)
  H[1,1] = 2
  H[2,2] = 2
  H[3,3] = 2
  H[2,1] = 0
  H[3,1] = 0
  H[3,2] = 0
end

@operator(model, op_sh_distance, 3, sh_distance, ∇sh_distance, ∇²sh_distance)

@objective(model, Max, op_sh_distance(x[1], x[2], x[3]))

print(model)

optimize!(model)

@assert is_solved_and_feasible(model)
solution_summary(model)

@show sqrt(objective_value(model))

value(x[1])
value(x[2])
value(x[3])

print(sqrt(sum(([value(x[1]), value(x[2]), value(x[3])] .- Shapley).^2)))
print(sqrt(sum(([900, 0, 0] .- Shapley).^2)))