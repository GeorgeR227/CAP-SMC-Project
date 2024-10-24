using Combinatorics

export Province, create_payoffs, calculate_budgets

# Province struct
struct Province
    name::String
    money::Float64
end

# Budget function based on 1/x
function budget_function(x::Int)
    return 1.0 / (x + 1)
end

# Function to calculate budgets and return a vector of Province structs
function calculate_budgets(players::Vector{String}, total_resources::Float64 = 100.0)
    num_provinces = length(players)
    raw_budgets = Vector{Float64}(undef, num_provinces)
    total_raw_budget = 0.0

    # Calculate budgets based on 1/x and sum them
    for i in 0:(num_provinces - 1)
        raw_budgets[i + 1] = budget_function(i)
        total_raw_budget += raw_budgets[i + 1]
    end

    country = Vector{Province}(undef, num_provinces)

    for i in 1:num_provinces
        normalized_budget = (raw_budgets[i] / total_raw_budget) * total_resources
        country[i] = Province(players[i], normalized_budget) 
    end

    return country
end

# Function to print payoffs based on conversion rates
function create_payoffs(power_set, conversion_rates::Dict{Int,Int})
    payOffs = Dict()
    for set in power_set
        if isempty(set)
            continue;
        end
        val_sum = 0
        name_list = String[]

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
