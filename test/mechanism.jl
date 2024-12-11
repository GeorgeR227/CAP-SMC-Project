using Test
using CAP_SMC_Project

function test_redistribution(country, budget, tax_type, expected_money) 
  res = sort_by_name(redistribution(country, budget; tax_type = tax_type))
  for (idx, val) in enumerate(expected_money)
    @test res[idx].name == country[idx].name && res[idx].money == expected_money[idx]
  end
end

function test_tax_non_grand_coalition_utilities(country, grand_coalition, tax_rate, expected_utilities)
  computed_utilities = tax_non_grand_coalition(country, grand_coalition, tax_rate)
  for (coalition, expected_utility) in expected_utilities
      sorted_coalition = sort_by_name(coalition)
      @test computed_utilities[sorted_coalition] == expected_utility
  end
end

@testset "Redistribution" begin

  nplayers = 3
  players = auto_generate_playertags(nplayers)
  provA = Province(players[1], 700)
  provB = Province(players[2], 400)
  provC = Province(players[3], 400)
  country = [provA, provB, provC]

  test_redistribution(country, 0, :flat, [700, 400, 400])
  test_redistribution(country, 0, :prop, [700, 400, 400])

  test_redistribution(country, 300, :flat, [600, 450, 450])
  test_redistribution(country, 300, :prop, [560, 470, 470])

  test_redistribution(country, 3000, :flat, [500, 500, 500])
end

@testset "Tax Non-Grand Coalition with Grand Coalition Argument" begin
  provA = Province("A", 700)
  provB = Province("B", 400)
  provC = Province("C", 400)
  country = [provA, provB, provC]

  # Example 1 Grand coalition includes all provinces
  grand_coalition = [provA, provB, provC]
  tax_rate = 0.05
  expected_utilities = Dict(
      [provA, provB, provC] => 1500.0,               # No tax on grand coalition
      [provA, provB] => 1100.0 * (1 - tax_rate),     # Taxed
      [provA] => 700.0 * (1 - tax_rate),             # Taxed
      [provB, provC] => 800.0 * (1 - tax_rate)       # Taxed
  )
  test_tax_non_grand_coalition_utilities(country, grand_coalition, tax_rate, expected_utilities)

  # Example 2 Grand coalition includes A and B
  grand_coalition = [provA, provB]
  expected_utilities = Dict(
      [provA, provB] => 1100.0,                      # No tax on grand coalition
      [provC] => 400.0 * (1 - tax_rate),             # Taxed
      [provA, provC] => 1100.0 * (1 - tax_rate)      # Taxed
  )
  test_tax_non_grand_coalition_utilities(country, grand_coalition, tax_rate, expected_utilities)

  # Example 3 Grand coalition includes only A
  grand_coalition = [provA]
  expected_utilities = Dict(
      [provA] => 700.0,                              # No tax on grand coalition
      [provB, provC] => 800.0 * (1 - tax_rate),      # Taxed
      [provA, provB] => 1100.0 * (1 - tax_rate)      # Taxed
  )
  test_tax_non_grand_coalition_utilities(country, grand_coalition, tax_rate, expected_utilities)
end
