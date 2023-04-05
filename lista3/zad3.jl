# LISTA 3 ZADANIE 3
using Plots
using .AcceptReject
using Distributions
using HypothesisTests

samples = accept_reject(Exponential(1), Normal(0, 1), sqrt(2ℯ/π), 1_000_00; mult=2)
samples = vcat(samples, -1 .* samples)

ExactOneSampleKSTest(samples, Normal(0, 1))
histogram(samples, normalize=:pdf, label="wartości wygenerowane metodą akceptacji-odrzucenia")
xs = LinRange(-3, 3, 1000)
plot!(xs, pdf.(Normal(0, 1), xs), lw=3, color=:red, label="funkcja gęstości standardowego rozkłądu normalnego")