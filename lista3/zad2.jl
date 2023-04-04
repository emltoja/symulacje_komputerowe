# LISTA 1 ZADANIE 2
using BenchmarkTools
using Plots
using .AcceptReject

pdf_sin(x) = sin(x)

@btime smpls = accept_reject(Uniform(0, π/2), pdf_sin, π/2, 1_000_000)
histogram(smpls, normalize=:pdf, label=false)

function pdf_sin_2(x)
    sqrtx = sqrt(x)
    return 1/(2 * sqrtx) * sin(sqrtx)
end

@btime smpls_2 = sqrt.(accept_reject(Uniform(0, π^2/4), pdf_sin_2, π^2/8, 1_000_000))
histogram(smpls_2, normalize=:pdf, label=false)