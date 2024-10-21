using Combinatorics

export Province, create_payoffs

# Province struct
struct Province
    name::String
    money::Int
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
