using Test

players = [:A, :B]

payoff = Dict(zip(powerset(players), [0, 5, 5, 20]))

shapley = shapley_point(payoff)

@test shapley == [10.0, 10.0]

players = [:A, :B, :C]

payoff = Dict(zip(powerset(players), [0, 0, 0, 0, 600, 600, 0, 900]))

shapley = shapley_point(payoff)

@test shapley == [500, 200, 200]
