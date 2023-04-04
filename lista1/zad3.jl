# Szacowanie liczby π
using LinearAlgebra
using IterTools
using .LinearCongruentialGenerator
using .Corput
using Plots

PiApprox(points)       = 4 * sum(norm.(points) .<= 1) / length(points)

LcgPi(size)            = zip(LCG(size, seed=6543234), LCG(size, seed=123456789)) |> PiApprox
HaltonPi(size, b1, b2) = zip(corput(size, b1), corput(size, b2)) |> PiApprox
UniformPi(size)        = product(0:1/sqrt(size):1, 0:1/sqrt(size):1) |> PiApprox

LcgPi(1000000)
HaltonPi(1000000, 31, 59)
UniformPi(1000000)

scatter(corput(1000, 41), corput(1000, 31))
scatter(LCG(1000, seed=6543234), LCG(1000, seed=123456789))

LcgErrs(size) = abs.(LcgPi.(1:size) ./ π .- 1)
HaltonErrs(size, b1, b2) = abs.(HaltonPi.(1:size, b1, b2) ./ π .- 1)
UniformErrs(size) = abs.(UniformPi.(1:size) ./ π .- 1)


size = 10000
histogram(LcgErrs(size), bins=round(Int, sqrt(size)), normalize=:pdf)
histogram(HaltonErrs(size, 31, 41), bins=round(Int, sqrt(size)), normalize=:pdf)
histogram(UniformErrs(size), bins=round(Int, sqrt(size)), normalize=:pdf)