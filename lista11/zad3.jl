# Lista 11 Zadanie 3
# Prawo iterowanego logarytmu
using Plots

function brown(times, dim)

    Δts = diff(times)
    pushfirst!(Δts, times[1])

    incs = randn(length(times), dim)

    for i in 1:dim
        incs[:, i] .*= sqrt.(Δts)
    end

    return cumsum(incs, dims=1)

end


function plot_lil(times)

    upper_limit = sqrt.(2times .* log.(log.(times)))

    plot(brown(times, 1), label=nothing)
    plot!(upper_limit, label=nothing)
    plot!(-upper_limit, label=nothing)

end

plot_lil(3:10000)