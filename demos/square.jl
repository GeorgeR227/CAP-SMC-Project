using LinearAlgebra
using JuMP
using Ipopt

# Regular 1x1 square, start at origin
println("Regular 1x1 square, start at origin")
model = Model(Ipopt.Optimizer)
set_silent(model)

@variable(model, 1 >= x >= 0)
@variable(model, 1 >= y >= 0)

@objective(model, Max, x^2 + y^2)

print(model)

optimize!(model)

primal_status(model)
dual_status(model)

println("Furthest distance is: $(sqrt(objective_value(model)))")

println("X: $(value(x)), Y: $(value(y))")

println()

# Regular 1x1 square with line through diagonal, start at origin
println("Regular 1x1 square with line through diagonal, start at origin")
model = Model(Ipopt.Optimizer)
set_silent(model)

@variable(model, 1 >= x >= 0, start = 0.5 + 0.0001)
@variable(model, 1 >= y >= 0, start = 0.5 - 0.0001)

@constraint(model, y + x == 1)

@objective(model, Max, x^2 + y^2)

print(model)

optimize!(model)

println("Furthest distance is: $(sqrt(objective_value(model)))")

println("X: $(value(x)), Y: $(value(y))")

@objective(model, Min, x^2 + y^2)

print(model)

optimize!(model)

println("Furthest distance is: $(sqrt(objective_value(model)))")

println("X: $(value(x)), Y: $(value(y))")
