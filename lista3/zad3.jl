# LISTA 3 ZADANIE 3
using Plots
using .AcceptReject
using Distributions

samples = accept_reject(Exponential(1), Normal(0, 1), sqrt(2ℯ/π), 1_000_000; mult=2)

histogram(samples, normalize=:pdf, label=false)