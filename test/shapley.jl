using Test
using CAP_SMC_Project
using Combinatorics

@testset "Small Shapley" begin
  players = [:A, :B]
  payoff = Dict(zip(powerset(players), [0, 5, 5, 20]))
  @test shapley_point(payoff) == [10.0, 10.0]

  players = [:A, :B, :C]
  payoff = Dict(zip(powerset(players), [0, 0, 0, 0, 600, 600, 0, 900]))
  @test shapley_point(payoff) == [500, 200, 200]
end