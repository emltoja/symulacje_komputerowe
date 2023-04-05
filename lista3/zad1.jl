# LISTA 3 ZADANIE 1
using Plots
using Distributions
using .AcceptReject

α = 3
den(x) = (α + 1) * x ^ α

samples = accept_reject(Uniform(0, 1), den, (α + 1), 100000)

histogram(samples, normalize=:pdf, label="wygenerowane wartości")
xs = LinRange(0, 1, 100)
plot!(xs, den.(xs), lw=3, color=:red, label="gęstość rzeczywista")