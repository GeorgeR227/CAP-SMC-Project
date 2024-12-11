using Test
using CAP_SMC_Project

function test_redistribution(country, budget, tax_type, expected_money) 
  res = sort_by_name(redistribution(country, budget; tax_type = tax_type))
  for (idx, val) in enumerate(expected_money)
    @test res[idx].name == country[idx].name && res[idx].money == expected_money[idx]
  end
end

function test_tax_non_grand_coalition(country, grand_coalition, expected_money)
  res = sort_by_name(tax_non_grand_coalition(country, grand_coalition))

  for (idx, val) in enumerate(expected_money)
      @test res[idx].name == country[idx].name && res[idx].money == expected_money[idx]
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

  # A and B are in the grand coalition
  grand_coalition = [provA, provB]  # A and B form the grand coalition
  test_tax_non_grand_coalition(country, grand_coalition, [700, 400, 380])

  # Only A is in the grand coalition
  grand_coalition = [provA]  # Only A forms the grand coalition
  test_tax_non_grand_coalition(country, grand_coalition, [700, 380, 380])

  # All provinces are in the grand coalition
  grand_coalition = [provA, provB, provC]  # Everyone is in the grand coalition
  test_tax_non_grand_coalition(country, grand_coalition, [700, 400, 400])
end
