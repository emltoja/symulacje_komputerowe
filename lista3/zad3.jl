# LISTA 3 ZADANIE 3
using Plots
using .AcceptReject
using Distributions

samples = accept_reject(Exponential(1), Normal(0, 1), sqrt(2ℯ/π), 1_000_00; mult=2)
samples = vcat(samples, -1 .* samples)
histogram(samples, normalize=:pdf, label=false)