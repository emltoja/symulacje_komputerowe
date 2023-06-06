# Lista 9 Zadanie 1

# Mieszany proces Poissona 
# Losowa miara Poissonowska 

using Distributions
using Plots 
using StatsBase
using Graphs
using GraphPlot

function discrete_poisson_measure(Ω, λ)
    
    N_Ω = rand(Poisson(λ * length(Ω)))
    result = rand(Ω, N_Ω)
    cntmap = countmap(result)
    freqs = [get(cntmap, key, 0) for key in Ω]
    gplot(path_graph(length(Ω)), nodelabel=freqs, layout=circular_layout)

    # bar(countmap(result), legend=nothing)
end

function cube_poisson_measure(a, λ)

    omega_measure = a^3
    N_Ω = rand(Poisson(λ * omega_measure))

    result = a * rand(N_Ω, 3)


    scatter3d(result[:,1], result[:,2], result[:,3], legend=nothing)
    plot3d!([0, 0], [0, 0], [0, a], color=:red)
    plot3d!([0, 0], [0, a], [0, 0], color=:red)
    plot3d!([0, a], [0, 0], [0, 0], color=:red)
    plot3d!([a, a], [0, 0], [0, a], color=:red)
    plot3d!([a, a], [0, a], [0, 0], color=:red)
    plot3d!([0, 0], [0, a], [a, a], color=:red)
    plot3d!([0, a], [0, 0], [a, a], color=:red)
    plot3d!([a, a], [0, a], [a, a], color=:red)
    plot3d!([a, a], [a, a], [a, 0], color=:red)
    plot3d!([0, a], [a, a], [a, a], color=:red)
    plot3d!([0, 0], [a, a], [0, a], color=:red)
    plot3d!([0, a], [a, a], [0, 0], color=:red)


end


function circle_poisson_measure(r, λ)

    omega_measure = π * r^2
    N_Ω = rand(Poisson(λ * omega_measure))

    points = Matrix{Float64}(undef, N_Ω, 2)


    for i in 1:N_Ω

        x = 2r * rand() - r
        y = 2r * rand() - r

        while x^2 + y^2 > r^2
            x = 2r * rand() - r
            y = 2r * rand() - r
        end

        points[i, 1] = x
        points[i, 2] = y
    end


    scatter(points[:, 1], points[:, 2], aspect_ratio=:equal, legend=nothing)
    plot!(r .* cos.(0:0.01:2π), r .* sin.(0:0.01:2π), color=:red, lw=3)

end

Ω = 1:20
λ = 30

discrete_poisson_measure(Ω, λ)


cube_poisson_measure(10, 1)


circle_poisson_measure(10, 10)

g = path_graph(9)
gplot(g, nodelabel=)