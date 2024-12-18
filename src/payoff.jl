using Combinatorics

export Province, create_payoffs, calculate_budgets, auto_generate_playertags, set_conversions

# Province struct
mutable struct Province
    name
    money::Float64
end

# Budget function based on 1/x
function budget_function(x::Int)
    return 1.0 / x
end

"""
    auto_generate_playertags(n)

Automatically generates unique players name for `n` players.
"""
function auto_generate_playertags(n)
  @assert n > 0

  pow = ceil(Int64, log2(n)/log2(26))

  name_gen = Iterators.product(fill('A':'Z', pow)...)

  return sort(["P_$(name...)" for (name, _) in zip(name_gen, 1:n)])
end

"""
    set_conversions(; ntimes::Int64 = 3, starting_price = 20, scaling_price = 500)

Automatically generates a set of price to crate conversions.
"""
function set_conversions(; ntimes::Int64 = 3, starting_price = 20, scaling_price = 500)
    
    conversion_rates = Dict{Int64, Float64}()

    for x in 1:ntimes
        currentPrice = starting_price + scaling_price * x
        crateNum = ceil((currentPrice)^2 / 1_000)
        conversion_rates[currentPrice] = crateNum
    end

    conversion_rates
end

"""
    calculate_budgets(players, total_resources::Float64 = 100.0; budget_func = budget_function)

Automatically distributes a set amount of funds to all players based on a provided budgeting
function. By default it is player id `i` receives a fraction `1/i` normalized to fit the total 
budget. This is meant as an initialization step and not as a mechanism.
"""
function calculate_budgets(players, total_resources::Float64 = 100.0; budget_func = budget_function)
    num_provinces = length(players)
    raw_budgets = Vector{Float64}(undef, num_provinces)
    total_raw_budget = 0.0

    # Calculate budgets based on 1/x and sum them
    for i in 1:num_provinces
        raw_budgets[i] = budget_func(i)
        total_raw_budget += raw_budgets[i]
    end

    country = Vector{Province}(undef, num_provinces)

    for i in 1:num_provinces
        normalized_budget = (raw_budgets[i] / total_raw_budget) * total_resources
        country[i] = Province(players[i], normalized_budget)
    end

    return country
end

"""
    create_payoffs(power_set, conversion_rates)

Creates the payoff dictionary based on the set of all coalitions as well as the given
economy of conversion rates. For simplicity, we assume that each coalition can only
purchase a single set of crates and that the utility of each crate increases as more are included.
"""
function create_payoffs(power_set, conversion_rates)
    payOffs = Dict()
    for set in power_set
        if isempty(set)
            continue;
        end
        val_sum = 0
        name_list = []

        for prov in set
            val_sum += prov.money
            push!(name_list, prov.name)
        end

        # Find the best fit crate
        temp_closest = 0
        best_fit_crate = 0
        for (cost, crates) in conversion_rates
            if cost > val_sum
                continue
            elseif cost == val_sum
                temp_closest = cost
                best_fit_crate = crates
                break
            elseif cost < val_sum
                if temp_closest < cost
                    temp_closest = cost
                    best_fit_crate = crates
                end
            end
        end

        push!(payOffs, name_list => best_fit_crate)
    end
    payOffs
end