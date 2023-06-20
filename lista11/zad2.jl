# Lista 11 Zadanie 2
# Estymacja odchylenia średniokwadratowego
using Plots

# Wielowymiarowy ruch Browna
function brown(times, dim)

    Δts = diff(times)
    pushfirst!(Δts, 0)

    incs = randn(length(times), dim)

    for i in 1:dim
        incs[:, i] .*= sqrt.(Δts)
    end

    return cumsum(incs, dims=1)

end

# Wektor E[X^2(t)] dla t z times
function mse(times, n)

    accum = zeros(length(times))

    for _ in 1:n
        accum .+= brown(times, 1).^2
    end

    return accum ./ n
end

# Wykres odchyleń średniokwadratowych
function plot_mse(times, n)
    scatter(
        times,
        mse(times, n),
        label=nothing,
        xlabel="t",
        ylabel="E[X^2]"
        )
end


plot_mse(1:0.1:100, 1000)