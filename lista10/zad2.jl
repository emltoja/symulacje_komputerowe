# Lista 10 Zadanie 2 
# Złożony proces Poissona

using Plots
using Distributions
using LaTeXStrings


# Czasy oczekiwania procesu Poissona
function poisson_proccess(T, λ)
    
    sum = 0 
    result = Float64[] 
    while true
            sum += rand(Exponential(1/λ))
            if sum < T
                push!(result, sum)
            else 
                return result 
            end
    end

end


# Wykres trajektorii procesu Poissona ze skokami z rozkładu d
function plot_trajectory(T, lambda, d :: Distribution)

    time_intervals = poisson_proccess(T, lambda)
    steps = pushfirst!(cumsum(rand(d, length(time_intervals) - 1)), 0)

    p = plot(
        title="Złożony Proces Poissona",
        xlabel=L"t",
        ylabel=L"X_t",
        legend=nothing
    )

    # plotowanie schodków 
    for i in 1:length(time_intervals) - 1
        plot!(p,
            time_intervals[i:i+1],
            [steps[i], steps[i]],
            color=:dodgerblue1,
            lw=2,
            label=nothing
        )

        plot!(p,
            [time_intervals[i + 1], time_intervals[i + 1]],
            steps[i:i+1],
            color=:dodgerblue1,
            lw=2,
            label=nothing
        )
    end

    return p

end


# Skoki o rozkładzie N(0, 1)
plot_trajectory(100, 1, Normal(0, 1))

# Skoki o rozkładzie C(0, 1)
plot_trajectory(100, 1, Cauchy(0, 1))