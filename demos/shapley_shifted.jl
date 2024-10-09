using LinearAlgebra
using JuMP
using Ipopt

# This is based on the example included in the first slides

shapley_A = ((2 * 0) + 600 + 600 + (2 * 900)) / 6
shapley_B = ((2 * 0) + 600 + 0 + (2 * 300)) / 6
shapley_C = ((2 * 0) + 600 + 0 + (2 * 300)) / 6

shapley = [shapley_A, shapley_B, shapley_C]

model = Model(Ipopt.Optimizer)

@variable(model, x[1:3])

@constraint(model, x[1] >= -500)
@constraint(model, x[2] >= -200)
@constraint(model, x[3] >= -200)

@constraint(model, x[1] + x[2] >= -100)
@constraint(model, x[1] + x[3] >= -100)
@constraint(model, x[2] + x[3] >= -400)

@constraint(model, x[1] + x[2] + x[3] == 0)

@objective(model, Max, x[1]^2 + x[2]^2 + x[3]^2)

print(model)

optimize!(model)

@assert is_solved_and_feasible(model)
solution_summary(model)

@show sqrt(objective_value(model))

value.(x) + shapley