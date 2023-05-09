# Zadanie 1 Lista 6
using Distributions
using HypothesisTests
using Plots

# Wygeneruj przedziały czasowe procesu poissona 
function poisson_proccess(T, λ)
    sum = 0 
    result :: Vector{Float64} = [] 
    while true
            sum += rand(Exponential(1/λ))
            if sum < T
                push!(result, sum)
            else 
                return result 
            end
    end
end

# Liczba zliczeń procesu poissona do czasu t 
function get_n(t, λ)

    n = 0
    sum = 0 

    while sum < t
        sum += rand(Exponential(1/λ))
        n += 1
    end

    return n - 1
end

xs = poisson_proccess(10, 5)
plot(xs, 0:length(xs)-1, linetype=:steppost)

time = 3
lambda = 3

ns = [get_n(time, lambda) for _ in 1:100_000]

histogram(ns, normalize=:probability, label="Rozkład wartości N($time) \n Dla λ = $lambda")
scatter!(0:3*lambda*time, pdf.(Poisson(time*lambda), 0:3*lambda*time), label="Rozkład P($(lambda * time)")

ChisqTest(hcat(ns, rand(Poisson(time * lambda), length(ns))))
