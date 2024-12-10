using Test
using CAP_SMC_Project

function test_redistribution(country, budget, tax_type, expected_money) 
  res = sort_by_name(redistribution(country, budget; tax_type = tax_type))
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
  test_redistribution(country, 3000, :prop, [500, 500, 500])

end
