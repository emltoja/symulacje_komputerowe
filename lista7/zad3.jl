# Lista 7 Zadanie 3

using Plots
using Distributions
using HypothesisTests
using .PoissonProcess


# Metoda odwrotnej dystrybuanty
function inverse_cdf(cdf, step)
    
    u = rand()
    x = 0
    
    while u > cdf(x)
        x += step
    end
    
    return x
    
end

# Czasy oczekiwania procesu Poissona
function nhpp_invcdf(T, m)
    
    N = rand(Poisson(m(T)))
    times = Vector{Float64}(undef, N)
    
    # Dystrybuanta
    cdf(t) = m(t) / m(T)
    
    for i in 1:N
        times[i] = inverse_cdf(cdf, 0.001)
    end

    return sort(times) 

end

# Ilość zliczeń w czasie t
function get_nt_invcdf(t, T, m)

    times = nhpp_invcdf(T, m)
    return findfirst(x -> x > t, times) - 1

end

function join_proccesses(times1, times2)
    return sort(vcat(times1, times2))
end

# Całka z l1
function m1(t)
    return 0.25t^2 + t 
end

# Całka z l2
function m2(t)
    return 0.15t^2 + 0.2t
end


t1 = nhpp_invcdf(10, m1)
t2 = nhpp_invcdf(10, m2)

t_joined = join_proccesses(t1, t2)


function proccess_distribution_invcdf(nts, t, m)

    histogram(
        nts,
        normalize=:probability,
        color=:dodgerblue1,
        label="Rozkład wartości niejednorodnego procesu poissona" 
    )

    # Zakres plotowania dla rozkładu Poissona
    plotting_range = 0:3m(t)

    # Rozkład Poissona
    scatter!(
        plotting_range,
        pdf.(Poisson(m(t)), plotting_range),
        color=:orange
    )

end


# Testy statystyczne 

nt1 = [get_nt_invcdf(2, 10, m1) for _ in 1:100_000]
nt2 = [get_nt_invcdf(2, 10, m2) for _ in 1:100_000]
nt_joined = [get_nt_invcdf(2, 10, x -> m1(x) + m2(x)) for _ in 1:10_000]

proccess_distribution_invcdf(nt_joined, 2, x -> m1(x) + m2(x))

pvalue(ExactOneSampleKSTest(nt1, Poisson(m1(2))), tail=:right)
pvalue(ExactOneSampleKSTest(nt2, Poisson(m2(2))), tail=:right)
pvalue(ExactOneSampleKSTest(nt_joined, Poisson(m1(2) + m2(2))), tail=:right)
