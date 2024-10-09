using LinearAlgebra
using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

@variable(model, 1 >= x >= 0)
@variable(model, 1 >= y >= 0)

@objective(model, Max, x^2 + y^2)

print(model)

optimize!(model)

primal_status(model)
dual_status(model)

objective_value(model)

@show distance = sqrt(objective_value(model))

value(x)
value(y)

shadow_price(c1)
shadow_price(c2)
