# Lista 11 Zadanie 4
# Procesy Levy'ego
using Plots
using Distributions
using AlphaStableDistributions

# Proces gamma
function gamma_proc(times, β, dim)

    Δts = diff(times)
    pushfirst!(Δts, times[1])

    incs = Matrix{Float64}(undef, length(times), dim)

    for i in 1:length(times)
        incs[i, :] = rand(Gamma(Δts[i], β), 1, dim)
    end

    return cumsum(incs, dims=1)

end


# Proces variance gamma
function variance_gamma_proc(times, β, dim)
    
    Δts = diff(times)
    pushfirst!(Δts, times[1])

    incs = Matrix{Float64}(undef, length(times), dim)

    for i in 1:length(times)
        incs[i, :] = rand(Normal(0, rand(Gamma(Δts[i], β))), 1, dim)
    end


    return cumsum(incs, dims=1)
end


# Proces α-stabilny
function stable_proc(times, α, dim)
    
    Δts = diff(times)
    pushfirst!(Δts, times[1])

    incs = Matrix{Float64}(undef, length(times), dim)

    for i in 1:length(times)
        incs[i, :] = rand(AlphaStable(α, 0, Δts[i]^(1/α), 0), 1, dim)
    end


    return cumsum(incs, dims=1)
end


# Wykres trajektorii procesu
function plot_proc(traj; kwargs...)
    if size(traj, 2) > 1
        plot(eachcol(traj)...; kwargs..., aspect_ratio=1)
    else 
        plot(traj; kwargs...)
    end
end


gamma_traj = gamma_proc(1:0.1:100, 1, 1)
var_gamma_traj = variance_gamma_proc(1:0.1:100, 1, 1)
alpha2_traj = stable_proc(1:0.1:100, 2, 1)
alpha1_traj = stable_proc(1:0.1:100, 1, 1)
alpha15_traj = stable_proc(1:0.1:100, 1.5, 1)
alpha05_traj = stable_proc(1:0.1:100, 0.5, 1)

plot_proc(gamma_traj; label=nothing, title="Proces gamma")
plot_proc(var_gamma_traj; label=nothing, title="Proces variance gamma")
plot_proc(alpha05_traj; label=nothing, title="Proces stabilny α=0.5")
plot_proc(alpha1_traj; label=nothing, title="Proces stabilny α=1")
plot_proc(alpha15_traj; label=nothing, title="Proces stabilny α=1.5")
# Proces stabilny dla α=2 ma przyrosty z rozkładu N(0, t), czyli jest procesem Wienera
plot_proc(alpha2_traj, label=nothing, title="Proces stabilny; α=2")
