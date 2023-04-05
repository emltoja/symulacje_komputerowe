# LISTA 1 ZADANIE 2
using BenchmarkTools
using Plots
using .AcceptReject
using Distributions

pdf_sin(x) = sin(x)

@btime accept_reject(Uniform(0, π/2), pdf_sin, π/2, 1_000_0)
samples = accept_reject(Uniform(0, π/2), pdf_sin, π/2, 1_000_000)
histogram(samples, normalize=:pdf, label="wygenerowane wartości")
xs = LinRange(0, π/2, 1000)
plot!(xs, pdf_sin.(xs), lw=3, label="gęstość rzeczywista")

function pdf_sin_2(x)
    sqrtx = sqrt(x)
    return 1/(2 * sqrtx) * sin(sqrtx)
end

@btime sqrt.(accept_reject(Uniform(0, π^2/4), pdf_sin_2, π^2/8, 1_000_0))
samples2 = sqrt.(accept_reject(Uniform(0, π^2/4), pdf_sin_2, π^2/8, 1_000_000))
histogram(samples2, normalize=:pdf, label=false)
plot!(xs, pdf_sin.(xs), lw=3, label="gęstość rzeczywista")