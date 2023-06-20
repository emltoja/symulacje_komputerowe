# Lista 11 Zadanie 1
# Wielowymiarowy ruch Browna
using Plots

# Trajektoria ruchu Browna
function brown(times, dim)

    Δts = diff(times)
    pushfirst!(Δts, 0)

    # Przyrosty z rozkładu N(0, t)
    incs = randn(length(times), dim)
    for i in 1:dim
        incs[:, i] .*= sqrt.(Δts)
    end

    return cumsum(incs, dims=1)

end

# Wykres trajektorii ruchu Browna
function plot_brown(times, n; kwargs...)
    if n > 1
        plot(eachcol(brown(times, n))...; kwargs..., aspect_ratio=1)
        scatter!(eachcol(zeros(1, n))..., markersize=3, color=:red, label="Punkt początkowy")
    else 
        plot(times, brown(times, n); kwargs...)
    end
end

# Jednowymiarowy ruch Browna
plot_brown(1:0.1:100, 1, label=nothing, title="Jednowymiarowy ruch Browna")
# Dwuwymiarowy 
plot_brown(1:0.1:100, 2, label=nothing, title="Dwuwymiarowy ruch Browna")
# Trójwymiarowy
plot_brown(1:0.1:100, 3, label=nothing, title="Trójwymiarowy ruch Browna")
