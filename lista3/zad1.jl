# LISTA 3 ZADANIE 1
using Plots
using BenchmarkTools
using Distributions
using .AcceptReject

α = 1
den(x) = (α + 1) * x ^ α

samples = accept_reject(Uniform(0, 1), den, (α + 1), 100000)

histogram(samples, normalize=:pdf, label=nothing)
