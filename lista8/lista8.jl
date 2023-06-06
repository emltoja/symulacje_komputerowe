# Lista 8

using Distributions
using StatsBase
using Plots 

# Zadanie 1
# Łańcuch Markowa

function markov_chain(
    start,      # Stan początkowy
    steps,      # Ilość kroków
    tran_mat    # Macierz przejścia
)
    
    # Trajektoria procesu 
    trajectory = Vector{Int}(undef, steps)
    trajectory[1] = start

    for i in 2:steps

        # Aktualny stan
        current = trajectory[i - 1]

        # Przejście w kolejny stan 
        next = findfirst(isequal(1), rand(Multinomial(1, tran_mat[current, :])))
        trajectory[i] = next
        
    end
    
    return trajectory

end

function get_times(trajectory)
    return countmap(trajectory)
end


function states_dist(start, steps, tran_mat)

    bar(
        get_times(string.(markov_chain(start, steps, tran_mat))),
        legend=nothing,
        title="Czas spędzony w poszczególnych stanach",
        )
        
end
    
start = 1
steps = 1000
tran_mat = [0.5 0.25 0.25; 0 0.5 0.5; 0.25 0.5 0.25]

# Czas przebywania w poszczególnych stanach 
get_times(markov_chain(start, steps, tran_mat))
states_dist(start, steps, tran_mat)


# Zadanie 2 
# Łańcuch Markowa w czasie ciągłym 

function cont_markov_chain(
    start,      # Stan początkowy
    max_time,   # Czas trwania procesu
    tran_mat,   # Macierz przejścia
    lambdas     # Wektor intensywności
)

    # Trajektoria procesu 
    trajectory = Int[]
    push!(trajectory, start)
    
   times = Float64[]
   current_time = 0
   
   while current_time <= max_time

    # Aktualny stan
    current = last(trajectory)
    
       # Czas oczekiwania na przejście do kolejnego stanu
       t = rand(Exponential(1/lambdas[current]))
       push!(times, t)
       current_time += t

       # Przejście w kolejny stan 
       next = findfirst(isequal(1), rand(Multinomial(1, tran_mat[current, :])))
       push!(trajectory, next)
       
   end
   
   return cumsum(times), trajectory

end

# Wykres trajektorii łańcucha Markowa w czasie ciągłym
function plot_cont_traj(start, max_time, tran_mat, lambdas)
    
    times, traj = cont_markov_chain(start, max_time, tran_mat, lambdas)
    
    
    p = scatter(
        [0, times...],
        traj,
        legend = nothing,
        )
        
    scatter!(
        p,
        times,
        traj[1:end-1],
        markercolor=:white
    )

    plot!(p, [0, times[1]], [traj[1], traj[1]], c=:blue)

    for i in 2:length(times)
        plot!(p, times[i-1:i], [traj[i], traj[i]], c=:blue)
    end
    
    return p
end


# Trajektoria procesu w czasie ciągłym 

max_time = 20
tran_mat_cont = [0 0.5 0.5; 1/3 0 2/3; 1 0 0]
lambdas  = [1, 2 ,0.7]

plot_cont_traj(start, max_time, tran_mat_cont, lambdas)

