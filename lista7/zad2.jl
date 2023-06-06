# Zadanie 2 Lista 7 
# Metoda odwrotnej dystrybuanty


using Plots 
using Distributions
using LaTeXStrings
using HypothesisTests
using .PoissonProcess

# Funkcja λ(t) = 0.5 * t + 1
function m(t)
    return 0.25 * t^2 + t 
end

# Wykres trajektorii procesu Poissona 
function plot_trajectory_invcdf(T, m)

    time_intervals = nhpp_invcdf(T, m)
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
function proccess_distribution_invcdf(tm, T, m, sample_size)
    
    nts = [get_nt_invcdf(tm, T, m) for _ in 1:sample_size]

    histogram(
        nts,
        normalize=:probability,
        color=:dodgerblue1,
        label="Rozkład wartości niejednorodnego procesu poissona \nw czasie $tm" 
    )

    # Zakres plotowania dla rozkładu Poissona
    plotting_range = 0:3m(tm)

    # Rozkład Poissona
    scatter!(
        plotting_range,
        pdf.(Poisson(m(tm)), plotting_range),
        color=:orange,
        label=L"Rozkład $ P(m(t)) $"
    )

end

plot_trajectory_invcdf(10, m)
proccess_distribution_invcdf(2, 10, m, 100_000)
pvalue(ExactOneSampleKSTest([get_nt_invcdf(2, 10, m) for _ in 1:100_000], Poisson(m(2))), tail=:right)