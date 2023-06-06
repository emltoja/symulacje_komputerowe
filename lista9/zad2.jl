# Lista 9 Zadanie 2
# Niejednorodna losowa miara poissonowska 

using Distributions
using Plots 

function inhomo_poisson_measure(r)

    λ_max = 1 

    N = rand(Poisson(λ_max * π * r^2)) 

    points = Float64[]

    while


end