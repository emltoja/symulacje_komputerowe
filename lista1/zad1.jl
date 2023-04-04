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

