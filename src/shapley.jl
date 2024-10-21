using Combinatorics

export calculate_shapely

function get_crate_size(value, conversion_rates)
    best_match = 0
    best_fit_crate = 0
    for (threshold, crate) in conversion_rates
        if threshold <= value && threshold > best_match
            best_match = threshold
            best_fit_crate = crate
        end
    end
    return best_fit_crate
end

# ONLY CONSIDERS GRAND COALITION 
function calculate_shapely(country::Vector{Province}, conversion_rates::Dict{Int,Int})
    shapley_values = Dict{String, Float64}()

    n = length(country)

    for province in country
        shapley_values[province.name] = 0.0
    end

    for perm in permutations(country)
        current_value = 0

        for (i, province) in enumerate(perm)
            marginal_contribution = get_crate_size((province.money + current_value), conversion_rates) - get_crate_size(current_value, conversion_rates)   


            shapley_values[province.name] += marginal_contribution

            current_value += province.money
        end
    end

    for province in country
        shapley_values[province.name] = shapley_values[province.name] / factorial(n)
    end

    return shapley_values
end 

function main()
    # Establishes Provinces
    provA = Province("A", 700)
    provB = Province("B", 400)
    provC = Province("C", 400)
    Country = [provA, provB, provC]

    # Establishes Conversion Rates Dict
    ConversionRates = Dict{Int64, Int64}(900 => 600, 1500 => 900, 2000 => 1500)

    # Calculate Shapley values and sort them by name
    shapley_values = calculate_shapely(Country, ConversionRates)

    # Print the sorted Shapley values
    for (name, value) in shapley_values
        println("Province $name Shapley value = $value")
    end
end

main()