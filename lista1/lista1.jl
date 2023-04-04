using LinearAlgebra
using IterTools
using Statistics
using Plots


############# ZADANIE 1 #############

# Linear Congruential Generator generuje liczby pseudoloswe z wykorzystaniem wzoru 
# Xₙ₊₁ = (aXₙ + c) mod p 

# Struktura do przechowywania poprzednio wylosowanej wartości 
mutable struct LcgGenerator
    state::Int
    a::Int
    c::Int
    p::Int
end

# Wewnętrzna metoda do generowania jednej liczby pseudoloswej
function LCG(g::LcgGenerator)
    new_state = (g.a * g.state) % g.p
    g.state = new_state
    return new_state / g.p
end

# Wewnętrzna metoda do generowania wektora liczb pseudolosowych 
function LCG(g::LcgGenerator, size::Int64)
    result = zeros(size)
    for i in 1:size
        result[i] = LCG(g)
    end
    return result
end

# Dla geeratora Minimal standard LCG mamy a = 7⁵, c = 0, p = 2³¹ - 1
function MinStdLCG(;seed::Int = 2^16 - 1)
    g = LcgGenerator(seed, 7^5, 0, 2^31 - 1)
    return LCG(g)
end


function MinStdLCG(size::Int64; seed::Int = 2^16 - 1)
    g = LcgGenerator(seed, 7^5, 0, 2^31 -1)
    return LCG(g, size)
end


scatter(1:1000, MinStdLCG(1000), markersize=2, label="Wartości liczb wylosowanych z MinStdLCG")
histogram(MinStdLCG(100000), normalize=:pdf, label="Rozkład wartości z MinStdLCG")
plot!((x -> 0 < x < 1 ? 1 : 0), color=:red, lw=3, label="Gęstość rozkładu jednorodnego U(0, 1)")


#################### ZADANIE 2 ######################


function corput(size::Int, base::Int)

    arr = round.(Int64, LinRange(1, size, size))
    new_base_nums = reverse.(string.(arr, base=base))
    
    # Wtórnej konwersji liczb na system dziesiętny dokonujemy w postaci całkowitolicbowej, 
    # gdyż tylko z takim typem radzi sobie wbudowana funkcja parse 
    denoms = base.^length.(new_base_nums)
    base_10_nums = parse.(Int, new_base_nums, base=base)

    result = base_10_nums ./ denoms # Przekształcenie wygenerowanych liczb do floatów z przedziału [0,1]


    return result

end

anim1 = @animate for b in 2:62
    scatter(1:1000, corput(1000, b), title="Baza: $b", legend=nothing)
end

gif(anim1, fps=5)

anim2 = @animate for b in 2:62
    histogram(corput(10000, b), bins=100, normalize=:pdf, label="Rozkład wartości ciągu van der Corputa w bazie $b")
    ylims!(0, 1.5)
    plot!((x -> 0 < x < 1 ? 1 : 0), color=:red, lw=3, label="Gęstość rozkładu jednorodnego U(0, 1)")
end

gif(anim2, fps=5)


##################### ZADANIE 3 #####################

PiApprox(points)       = 4 * sum(norm.(points) .<= 1) / length(points)

# Przybliżenia liczby Pi dla danych próbek
LcgPi(size)            = zip(MinStdLCG(size, seed=6543234), MinStdLCG(size, seed=123456789)) |> PiApprox
HaltonPi(size, b1, b2) = zip(corput(size, b1), corput(size, b2)) |> PiApprox
UniformPi(size)        = product(0:1/sqrt(size):1, 0:1/sqrt(size):1) |> PiApprox

print(round.((LcgPi(1_000_000), pi); digits=6))
print(round.((HaltonPi(1_000_000, 51, 31), pi); digits=6))
print(round.((UniformPi(1_000_000), pi); digits=6))


Errs(sample) = abs.(sample ./ π .- 1)

LcgErrs(size) = LcgPi.(1:size) |> Errs
HaltonErrs(size, b1, b2) = HaltonPi.(1:size, b1, b2) |> Errs
UniformErrs(size) = UniformPi.(1:size) |> Errs


size = 10000
lcg_errs = LcgErrs(size)
println("Średni błąd: $(mean(lcg_errs))")
println("Odchylenie standardowe: $(std(lcg_errs))")

histogram(lcg_errs, bins=round(Int, sqrt(size)), normalize=:pdf, legend=nothing, title="Rozkład błęów przybliżenia z LCG")

hal_errs = HaltonErrs(size, 31, 51)
println("Średni błąd: $(mean(hal_errs))")
println("Odchylenie standardowe: $(std(hal_errs))")

histogram(hal_errs, bins=round(Int, sqrt(size)), normalize=:pdf, legend=nothing, title="Rozkład błędów przybliżenia z ciągami Haltona")

uni_errs = UniformErrs(size)
println("Średni błąd: $(mean(uni_errs))")
println("Odchylenie standardowe: $(std(uni_errs))")

histogram(uni_errs, bins=round(Int, sqrt(size)), normalize=:pdf, legend=nothing, title="Rozkład błędów przybliżenia z jednorodnym podziałem")


################ ZADANIE 4 ######################

function ThrowNeedles(length, size)
    midpoints = rand(size)./2 .+ 0.5 # Losujemy środek igły z przedziału [0.5, 1]
    angles = rand(size) .* π./2      # kąt z przedziału [0, π/2]

    count = sum(midpoints .+ length/2 .* sin.(angles) .> 1) # Liczba igieł, które przecieły linię

    return size / (count * 2 * length)
end

needle_lengths = LinRange(0.1, 2, 100)
needle_approximations = ThrowNeedles.(needle_lengths, 10000) ./ π
scatter(needle_lengths, needle_approximations, legend=nothing, xlabel= "Długość igły", ylabel="Przybliżenie π")


