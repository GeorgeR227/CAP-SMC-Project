using Printf

# Province struct
struct Province
    name::String
    money::Int
end

# Function to generate the power set of provinces
function power_set(country::Vector{Province})
    pow_list = Vector{Vector{Province}}([])
    size = 2 ^ length(country)
    push!(pow_list, Vector{Province}())

    for prov in country
        pow_set_size = length(pow_list)
        for x in 1:pow_set_size
            temp_vec = copy(pow_list[x])
            push!(temp_vec, prov)
            push!(pow_list, temp_vec)
        end
    end

    # Remove the empty set
    return pow_list[2:end]
end

# Function to print payoffs based on conversion rates
function print_payoffs(power_set::Vector{Vector{Province}}, conversion_rates::Dict{Int,Int})
    for set in power_set
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

        # Print the result
        println("(" * join(name_list, ", ") * ") can buy: $best_fit_crate crates with a total of \$$val_sum")
    end
end

# Main function to run the program
function main()

    #Establishes Provinces
    provA = Province("A", 700)
    provB = Province("B",400)
    provC = Province("C", 400)

    Country = [provA, provB, provC]

    #Establishes Conversion Rates Dict
    ConversionRates = Dict{Int64, Int64}(900 => 600, 1500 => 900, 2000 => 1500)

    # Generate the power set of provinces
    pow_set = power_set(Country)

    # Print the payoffs
    print_payoffs(pow_set, ConversionRates)
end

# Call the main function
main()