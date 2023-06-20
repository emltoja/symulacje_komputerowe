# Lista 11 Zadanie 1
# Wielowymiarowy ruch Browna
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


function plot_brown(times, n)
    plot(eachcol(brown(times, n))...)
end



