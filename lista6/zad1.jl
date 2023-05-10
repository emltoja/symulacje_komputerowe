# Zadanie 1 Lista 6
using Distributions
using HypothesisTests
using LaTeXStrings
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

function plot_trajectory(T, λ)

    time_intervals = poisson_proccess(T, λ)
    nts = 0:length(time_intervals) - 1

    plot(
        title="Proces Poissona",
        xlabel=L"t",
        ylabel=L"N_t",
        legend=nothing
    )

    # plotowanie schodków 
    for i in 1:length(time_intervals) - 1
        plot!(time_intervals[i:i+1], [nts[i], nts[i]], color=:dodgerblue1, lw=2, label=nothing)
    end

    # przedziały domknięte lewostronnie
    scatter!(time_intervals[1:end-1], nts[1:end-1], markersize=3, markercolor=:dodgerblue1, label=nothing)

    # otwarte prawostronnie 
    scatter!(time_intervals[2:end], nts[1:end-1], markersize=3, markercolor=:white, label=nothing)

end

plot_trajectory(10, 2)

t = 3
lambda = 3

ns = [get_n(t, lambda) for _ in 1:100_000]

histogram(ns, normalize=:probability, label="Rozkład wartości N($time) \n Dla λ = $lambda")
scatter!(0:3*lambda*time, pdf.(Poisson(time*lambda), 0:3*lambda*time), label="Rozkład P($(lambda * time)")

ChisqTest(hcat(ns, rand(Poisson(time * lambda), length(ns))))
