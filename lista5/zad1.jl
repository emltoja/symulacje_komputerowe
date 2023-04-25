# LISTA 5 ZADANIE 1
using Plots
using Distributions
using BenchmarkTools

# Algorytm Boxa-Mullera
function boxmuller(size :: Int)

    U = rand(Exponential(1), size)
    Θ = 2π .* rand(size)


    R = sqrt.(2 .* U)
    X = R .* cos.(Θ)
    Y = R .* sin.(Θ)

    return (X, Y)

end

# Alogrytm Marsaglii
function marsaglia(size :: Int)
   
    Z = Vector{Float64}(undef, size)
    W = Vector{Float64}(undef, size)

    for i in eachindex(Z)
        x = 2 * rand() - 1
        y = 2 * rand() - 1
        while x^2 + y^2 > 1
            x = 2 * rand() - 1
            y = 2 * rand() - 1
        end
        Z[i] = x
        W[i] = y  
    end

    R2 = Z .^2 + W .^2
    C = sqrt.(-2log.(R2) ./ R2)

    X = C .* W
    Y = C .* Z

    return (X, Y)

end

#################################
# Generowanie metodą Boxa-Mullera
#################################

samples_b = boxmuller(1_000_000)

# Gęstości brzegowe
histogram(samples_b[1])
histogram(samples_b[2])

# Gęstość łączna
histogram2d(samples_b, aspect_ratio=1, normalize=:pdf)


# Testy statystyczne

# Test Kołmogorova - Smirnoffa
ExactOneSampleKSTest(samples_b[1], Normal(0, 1))
ExactOneSampleKSTest(samples_b[2], Normal(0, 1))

# Test Andersona - Darlinga
OneSampleADTest(samples_b[1], Normal(0, 1))
OneSampleADTest(samples_b[2], Normal(0, 1))

# Test Jarque - Bera 
JarqueBeraTest(samples_b[1])
JarqueBeraTest(samples_b[2])



##############################
# Generowanie metodą Marsaglii
##############################

samples_m = marsaglia(1_000_000)


# Gęstości brzegowe
histogram(samples_m[1], normalize = :pdf, legend = false)
histogram(samples_m[2], normalize = :pdf, legend = false)
histogram2d(samples_m, aspect_ratio=1, normalize=:pdf)


# Testy statystyczne

# Test Kołmogorova - Smirnoffa
ExactOneSampleKSTest(samples_m[1], Normal(0, 1))
ExactOneSampleKSTest(samples_m[2], Normal(0, 1))

# Test Andersona - Darlinga
OneSampleADTest(samples_m[1], Normal(0, 1))
OneSampleADTest(samples_m[2], Normal(0, 1))

# Test Jarque - Bera 
JarqueBeraTest(samples_m[1])
JarqueBeraTest(samples_m[2])



#######################
# Porównanie wydajności
#######################

@btime boxmuller(1_000_000)
@btime marsaglia(1_000_000)