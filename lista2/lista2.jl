# LISTA 2

using BenchmarkTools
using BenchmarkPlots
using Distributions
using HypothesisTests
using KernelDensity
using Plots
using SpecialFunctions
using StatsBase
using StatsPlots

sample_size = 100000

function benchmark(f)
    suite = BenchmarkGroup()
    for x in 1:10
        suite[1000*x] = @benchmarkable $(f).(rand(1000*$x));
    end
    tune!(suite)
    run(suite, verbose=true, samples=100)

end

#################
# ROZKŁADY CIĄGŁE
#################

# ----------------- ROZKŁAD WYKŁADNICZY ----------------
λ = 2
exp_inverse_dist(x) = -λ * log(x)
exp_samples = exp_inverse_dist.(rand(sample_size))

# Złożoność czasowa generowania zmiennych
exp_bench_result = benchmark(exp_inverse_dist)
plot(
    exp_bench_result,
    title="Złożoność czasowa generowania zmiennych z rozkładu wykładniczego\nprzy 100 powtórzeniach dla każdej próbki",
    xlabel="rozmiar próbki",
    titlefontsize=10
    )


# Gęstości
xs = LinRange(0, 10, 100)
histogram(exp_samples, normalize=:pdf, label="Gęstość empiryczna")
plot!(xs, pdf.(Exponential(λ), xs), lw=3, color=:red, label="Gęstość rozkładu wykładniczego")

# Test Kołmogorowa-Smirnowa
ExactOneSampleKSTest(exp_samples, Exponential(λ))


# ---------------- ROZKŁAD NORMALNY --------------------
μ = 0
σ² = 1
σ = sqrt(σ²)

norm_inverse_dist(x) = μ + sqrt(2*σ²) * erfinv.(2 * x - 1)
norm_samples = norm_inverse_dist.(rand(sample_size))

# Złożoność czasowa generowania zmiennych
norm_bench_result = benchmark(norm_inverse_dist)
plot(
    norm_bench_result,
    title="Złożoność czasowa generowania zmiennych z rozkładu normalnego\nprzy 100 powtórzeniach dla każdej próbki",
    xlabel="rozmiar próbki",
    titlefontsize=10
    )

# Gęstości
xs = LinRange(μ -3σ, μ + 3σ, 100)
histogram(norm_samples, normalize=:pdf, label="Gęstość empiryczna")
plot!(-3:0.06:3, pdf.(Normal(μ, σ), -3:0.06:3), lw=3, color=:red, "Gęstość rozkładu normalnego")

# Jądrowy estymator pdf
kern_den = kde(norm_samples)
plot(xs, pdf(kern_den, xs), label="jądrowy estymator gęstości")
plot!(xs, pdf.(Normal(μ, σ), xs), label="dokładna gęstość")

# Test Kołmogorowa-Smirnowa
ExactOneSampleKSTest(norm_samples, Normal(μ, σ))


# -------------- ROZKŁAD CAUCHYEGO ----------------------
μ = 0
γ = 1

cauchy_inverse_dist(x) = μ .+ γ .* tan.(π .* (x .- 1/2))
cauchy_samples = cauchy_inverse_dist(rand(sample_size))

# Złożoność czasowa generowania zmiennych
cauchy_bench_result = benchmark(cauchy_inverse_dist)
plot(
    cauchy_bench_result,
    title="Złożoność czasowa generowania zmiennych z rozkładu normalnego\nprzy 100 powtórzeniach dla każdej próbki",
    xlabel="rozmiar próbki",
    titlefontsize=10
    )

# Gęstości
xs = LinRange(-10, 10, floor(Int, sqrt(sample_size)))
histogram(cauchy_samples, bins=xs, normalize=:pdf, label="Gęstość empiryczna")
plot!(xs, pdf.(Cauchy(μ, γ), xs), lw=3, color=:red, label="Gęstość rozkładu Cauchy'ego")

# Test Kołmogorowa-Smirnowa
ExactOneSampleKSTest(cauchy_samples, Cauchy(μ, γ))

####################
# ROZKŁADY DYSKRETNE
####################

# Funkcja tworząca wykresy rozkładu masy prawdopodobieństwa rozkładów dyskretnych
function plot_pmf(sample; kwargs...)
    # Słownik zliczający wystąpienia konkretnych wartości w rozkładzie
    counts  = Dict{Int64, Float64}(sort(collect(countmap(sample)), by = x -> x[1]))

    # Unormowanie
    map!(x -> x / length(sample), values(counts))


    scatter(collect(keys(counts)), collect(values(counts)); kwargs...)
end

# ------------- ROZKŁAD GEOMETRYCZNY ---------------------

prob = 0.5
geo_inverse_dist_algo(x, p) = ceil(log(x) / log(1 - p))# Algorytm generowania rozkładu wykładniczego z jednostajnego podany na wykładzie


# Rozkłady masy
function plot_geo_samples(p)
    geo_samples = geo_inverse_dist_algo.(rand(sample_size), p)
    p1 = plot_pmf(geo_samples, ylims=(0, 1), title="Rozkład wygenerowanych zmiennych", legend=false, titlefontsize=10);
    p2 = scatter(1:max(geo_samples...), pdf.(Geometric(p), 0:max(geo_samples...)), color=:green, ylims=(0, 1), title="Rozkład geometryczny", legend=false, titlefontsize=10);
    plot(p1, p2, layout=grid(1, 2))
end

plot_geo_samples(prob)
geo_samples = geo_inverse_dist_algo.(rand(sample_size), prob)

# Test Kołmogorowa-Smirnowa
pvalue(ExactOneSampleKSTest(geo_samples, Geometric(prob)), tail=:right)

# ----------- ROZKŁAD POISSONA ------------------------

λ = 5

# Algorytm generowania rozkładu Poissona z rozkładu jednostajnego podany na wykładzie
function generate_poisson(l_val, size)
    uni_samples = rand(size)
    poisson_samples = zeros(size)
    x = 0
    l = l_val
    p = exp(-l)
    s = p

    while any(uni_samples .> s)
        poisson_samples .+= (uni_samples .> s)
        x += 1
        p *= l/x
        s += p 
    end

    poisson_samples
end
poisson_samples = generate_poisson(λ, 1_000_000)

# Rozkłady masy
xs = LinRange(0, 30, 31)
plot_pmf(poisson_samples, markersize=2, label="Rozkład wygenerowanych zmiennych")
scatter!(xs, pdf.(Poisson(λ), xs), markersize=2, label="Funkcja masy rozkładu Poissona")

# Test Kołmogorowa-Smirnowa
pvalue(ExactOneSampleKSTest(poisson_samples, Poisson(λ)), tail=:right)

# ---------- GENEROWANIE METODĄ TABLICOWĄ ---------------

function lookup_table(prob_vec, size)

    prob_vec = rationalize.(prob_vec)
    least_common_denominator = lcm(denominator.(prob_vec)...)
    numerators = numerator.(least_common_denominator .* prob_vec)
    
    lookup_table = vcat([[i for _ in 1:x] for (i, x) in enumerate(numerators)]...)
    sample(lookup_table, size)

end

lookup_table_samples = lookup_table([0.2, 0.3, 0.5], 100000)
countmap(lookup_table_samples) # częstość występowania wylosowanych wartości. Zgodna z zadanymi prawdopodobieństwami.