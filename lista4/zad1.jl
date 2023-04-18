# LISTA 4 ZADANIE 1   
using Plots
using Distributions
using HypothesisTests

# Generowanie zmiennych losowych 
function generate(h :: Function, xrange :: Int, yrange :: Int, size :: Int)

    samples = Vector{Float64}(undef, size)

    prev_filled_count = 0
    filled_count = 0
    N = size
    
    while filled_count < size
       
        x = xrange .* rand(N)                 # x ∈ [0, xrange]
        y = 2yrange .* rand(N) .- yrange       # y ∈ [-yrange, yrange]
        z = y ./ x
       
        mask = x.^2 .<= h.(z)

        filled_now = sum(mask)
        filled_count += filled_now
        N -= filled_now

        samples[1+prev_filled_count:filled_count] = z[mask][1:filled_count-prev_filled_count]
        prev_filled_count = filled_count
    end

    return samples

end


# ----------------------
# GENEROWANIE ROZKŁADÓW
# ----------------------

cauchy(x) = 1/(1 + x^2)
normal(x) =ℯ^(-x^2/2)

# Wygenerowanie próbki z rozkładu N(0, 1)
normal_samples = generate(normal, 1, 1, 10000)

# Gęstości
histogram(normal_samples, normalize=:pdf, label=false)
normal_xs = LinRange(-5, 5, 100)
plot!(normal_xs, pdf.(Normal(0, 1), normal_xs), lw=3, color=:red)

# Testy Statystyczne
ExactOneSampleKSTest(normal_samples, Normal(0, 1))


# Wygenerowanie próbki z rozkładu C(0, 1)
cauchy_samples = generate(cauchy, 1, 1, 10000)

# Gęstości
cauchy_xs = LinRange(-10, 10, 200)
histogram(cauchy_samples, normalize=:pdf, label=false, bins=cauchy_xs)
plot!(cauchy_xs, pdf.(Cauchy(0, 1), cauchy_xs), lw=3, color=:red)

# Testy Statystyczne
ExactOneSampleKSTest(cauchy_samples, Cauchy(0, 1))