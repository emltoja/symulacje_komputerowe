# Lista 10 Zadanie 3 
# Procesy ryzyka 

using Plots
using Distributions


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


function risk_process(T, lambda, d :: Distribution, u, c)
    
    # Momenty, w których dochodzi do szkody
    time_intervals = poisson_proccess(T, lambda)
    # Szkody z rozkładu d
    damages = rand(d, length(time_intervals))

    # Przedział czasowy, na którym modelujemy kapitał
    ts = 0:0.1:T
    # Indeksy momentów szkód w ts
    idx = findfirst.([[t < t0 for t0 in ts] for t in time_intervals])
    # Stałe przychody
    incomes = collect(c .* ts)

    # Odjęcie szkód od przychodów 
    for (i, j) in enumerate(idx) 
        incomes[j:end] .-= damages[i]
    end

    steps = u .+ incomes

    return (collect(ts), steps)
end

# Wykres trajektorii procesu Poissona ze skokami z rozkładu d
function plot_risk_trajectory(T, lambda, d :: Distribution, u, c)

    ts, steps = risk_process(T, lambda, d, u, c)

    plot(
        ts, 
        steps,
        title="Proces Ryzyka",
        xlabel="t",
        ylabel="Kapitał",
        legend=nothing
    )

end

function bankrupcy_risk(t, T, lambda, d :: Distribution, u, c; num_of_runs=1000)

    result = 0

    for _ in 1:num_of_runs
        ts, steps = risk_process(T, lambda, d, u, c)
        result += steps[findfirst(ts .== t)] < 0
    end

    return result / num_of_runs

end

# Trajektoria procesu ryzyka
plot_risk_trajectory(10, 1, Exponential(1), 5, 0.5)

# Ryzyko niewypłacalności 
for t in (1, 3, 5)
    println("Ryzyko niewypłacalności w czasie $t: $(bankrupcy_risk(t, 10, 1, Exponential(1), 5, 0.5))")
end