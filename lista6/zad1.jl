# Zadanie 1 Lista 6
using Distributions
using HypothesisTests
using LaTeXStrings
using Plots


# Wygeneruj czasy oczekiwania procesu poissona 
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


# Liczba zgłoszeń do czasu t 
function get_n(t, λ)

    n = 0
    sum = 0 

    while sum < t
        sum += rand(Exponential(1/λ))
        n += 1
    end

    return n - 1

end


# Wykres trajektorii procesu Poissona 
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
        plot!(
            time_intervals[i:i+1],
            [nts[i], nts[i]],
            color=:dodgerblue1,
            lw=2,
            label=nothing
        )
    end

    # przedziały domknięte lewostronnie
    scatter!(
        time_intervals[1:end-1],
        nts[1:end-1],
        markersize=3,
        markercolor=:dodgerblue1,
        label=nothing
    )

    # otwarte prawostronnie 
    scatter!(
        time_intervals[2:end],
        nts[1:end-1],
        markersize=3,
        markercolor=:white,
        label=nothing
    )

end


# Rozkład liczby zgłoszeń do czasu `tm`
function proccess_distribution(tm, λ, sample_size)
    
    nts = [get_n(tm, λ) for _ in 1:sample_size]

    histogram(
        nts,
        normalize=:probability,
        color=:dodgerblue1,
        label=L"Rozkład wartości $ N_{%$tm} $" * "\n" * L"Dla $ λ = %$λ $"    
    )

    # Zakres plotowania dla rozkładu Poissona
    plotting_range = 0:3*λ*tm

    # Rozkład Poissona
    scatter!(
        plotting_range,
        pdf.(Poisson(λ*tm), plotting_range),
        color=:orange,
        label=L"Rozkład $ P(%$(λ*tm)) $"
    )

end


# Test Chi kwadrat z hipotezą zerową, że liczba zgłoszeń do danej chwili
# pochodzi z rozkładu Poissona. 
function test_for_poisson(tm, λ, sample_size)

    nts = [get_n(tm, λ) for _ in 1:sample_size]
    ChisqTest(hcat(nts, rand(Poisson(tm * λ), sample_size)))

end




plot_trajectory(10, 2)
proccess_distribution(4, 2, 100_000)
test_for_poisson(5, 3, 100_000)
