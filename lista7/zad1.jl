# Lista 7 Zadanie 1
# Generowanie niejednorodnego procesu Poissona metodą przerzedzania

using Plots
using Distributions
using LaTeXStrings
using .PoissonProcess

l = 0.5

function lambda(t)
    return l * t + 1
end


# Wykres trajektorii procesu Poissona 
function plot_trajectory(T, lambda)

    time_intervals = nhpp(T, lambda)
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
function proccess_distribution(tm, T, sample_size)
    
    nts = [get_nt(tm, T, lambda) for _ in 1:sample_size]

    histogram(
        nts,
        normalize=:probability,
        color=:dodgerblue1,
        label="Rozkład wartości niejednorodnego procesu poissona" 
    )

    # Zakres plotowania dla rozkładu Poissona
    plotting_range = 0:2*l*tm^2+4

    # Rozkład Poissona
    scatter!(
        plotting_range,
        pdf.(Poisson(l * tm^2 / 2 + tm), plotting_range),
        color=:orange,
        label=L"Rozkład $ P(%$(l*tm^2 / 2 + tm)) $"
    )

end

plot_trajectory(10, lambda)
proccess_distribution(3, 10, 100000)    