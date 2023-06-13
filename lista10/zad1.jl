# Lista 10 Zadanie 1 
# Estymator funkcji charakterystycznej

using Distributions
using Plots

# Fukcja estymująca funkcję charakterystyczną
function char_func(sample)
    return x -> sum(exp.((im * x) .* sample)) / length(sample)
end


# Funkcje charakterystyczne rozkładów Poissona, wykładniczego i normalnego
function poiss_char(λ, t)
    return exp(λ * (exp(im * t) - 1))
end

function exp_char(λ, t)
    return 1 / (1 - im * t / λ)
end

function norm_char(μ, σ, t)
    return exp(μ*im*t - (σ*t)^2/2)
end


# Przedstawienie na wykresie wektora liczb zespolonych za pomocą 
# modułu i argumentu.
function plot_im(ts, vals)

    magnitude_plot = scatter(ts, abs.(vals), legend=nothing, title="Moduł")
    angle_plot = scatter(ts, angle.(vals) .% pi, legend=nothing, title="Argument")

    plot(magnitude_plot, angle_plot, layout=@layout grid(2, 1))

end

# X ~ Pois(1)
poiss_sample = rand(Poisson(1), 1000)
poiss_sample_char = char_func(poiss_sample)

# X ~ Exp(1)
exp_sample = rand(Exponential(1), 1000)
exp_sample_char = char_func(exp_sample)

# X ~ N(1, 1)
norm_sample = randn(10000) .+ 1
norm_sample_char = char_func(norm_sample)

ts = -3:0.1:3


# Rozkład Poissona
plot_im(ts, poiss_sample_char.(ts))
plot_im(ts, poiss_char.(1, ts))


# Rozkład wykładniczy
plot_im(ts, exp_sample_char.(ts))
plot_im(ts, exp_char.(1, ts))


# Rozkład normalny
plot_im(ts, norm_sample_char.(ts))
plot_im(ts, norm_char.(1, 1, ts))

