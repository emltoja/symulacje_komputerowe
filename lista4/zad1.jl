# LISTA 4 ZADANIE 1   
using Plots
using Distributions
using HypothesisTests

# Generowanie zmiennych losowych 
function generate(h :: Function, xrange :: Int, yrange :: Int)

    x = xrange * rand()                 # x ∈ [0, xrange]
    y = 2yrange * rand() - yrange       # y ∈ [-yrange, yrange]
    
    if x^2 <= h(y/x)
        return y/x
    else 
        generate(h, xrange, yrange)

    end
end

cauchy(x) = 1/(1 + x^2)
normal(x) =ℯ^(-x^2/2)

# --------------
# TESTOWANIE
# --------------

# Wygenerowanie próbki z rozkładu N(0, 1)
normal_samples = [generate(normal, 1, 1) for _ in 1:1000000]

# Gęstości
histogram(normal_samples, normalize=:pdf, label=false)
normal_xs = LinRange(-5, 5, 100)
plot!(normal_xs, pdf.(Normal(0, 1), normal_xs), lw=3, color=:red)

# Testy Statystyczne
ExactOneSampleKSTest(normal_samples, Normal(0, 1))


# Wygenerowanie próbki z rozkładu C(0, 1)
cauchy_samples = [generate(cauchy, 1, 1) for _ in 1:1000000]

# Gęstości
cauchy_xs = LinRange(-10, 10, 200)
histogram(cauchy_samples, normalize=:pdf, label=false, bins=cauchy_xs)
plot!(cauchy_xs, pdf.(Cauchy(0, 1), cauchy_xs), lw=3, color=:red)

# Testy Statystyczne
ExactOneSampleKSTest(cauchy_samples, Cauchy(0, 1))