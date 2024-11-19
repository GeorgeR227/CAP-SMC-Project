using Test

@testset "Shapley" begin
  include("shapley.jl")
end

@testset "Mechanisms" begin
  include("mechanism.jl")
end