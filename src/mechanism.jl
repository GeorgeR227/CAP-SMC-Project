using Combinatorics

export redistribution, sort_by_name, benefit, penalty

function redistribution(country, budget; tax_type = :prop)

  @assert budget >= 0

  nplayers = length(country)
  real_budget = 0
  totalMoney = 0

  for prov in country
    totalMoney = totalMoney+prov.money
  end

  new_country = []

  totalMoney = sum(prov.money for prov in country)  

for prov in country
    if tax_type == :flat
        tax = min(prov.money, ceil(budget / nplayers))
        push!(new_country, Province(prov.name, prov.money - tax))
        real_budget += tax
    else 
        tax = min(prov.money, ceil(budget * (prov.money/totalMoney))) 
        push!(new_country, Province(prov.name, prov.money - tax))
        real_budget += tax
    end
end
  
  new_country = sort(new_country; by = x -> x.money)

  for (idx, prov) in enumerate(new_country[2:end])

    next_goal = prov.money

    money_to_reach_goal = 0
    available_money = 0

    for i in 1:(idx)
      money_to_reach_goal += next_goal - new_country[i].money
      available_money += new_country[i].money
    end

    money_to_use = min(real_budget, money_to_reach_goal)
    real_budget -= money_to_use

    real_goal = min(next_goal, (available_money + money_to_use) / (idx))

    for i in 1:idx
      new_country[i].money = real_goal
    end
  end

  final_distribution = real_budget / nplayers
  for prov in new_country
    prov.money += final_distribution
  end
  
  sort_by_name(new_country)
end

sort_by_name(country) = sort(country; by = x -> x.name)


function benefit(players, payoff, reward)

  for coalition in powerset(players)
    if isempty(coalition); continue; end
    payoff[coalition] += reward
  end

  payoff[players] -= reward

  payoff
end

function tax_non_grand_coalition(country; tax_rate = 0.05)
  coalitions = collect(powerset(country))

  grand_coalition = reduce((a, b) -> length(a) > length(b) ? a : b, coalitions)

  grand_coalition_names = Set([prov.name for prov in grand_coalition])

  taxed_country = []

  for prov in country
      # ∉ is symbol for "not in" one of the only clean ways to do this in julia 
      if prov.name ∉ grand_coalition_names
          tax = prov.money * tax_rate
          remaining_money = prov.money - tax
          push!(taxed_country, Province(prov.name, remaining_money))
      else
          push!(taxed_country, prov)
      end
  end

  return taxed_country  
end

penalty(players, payoff, reward) = benefit(players, payoff, -reward)