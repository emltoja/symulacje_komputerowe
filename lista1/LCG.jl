module LinearCongruentialGenerator
    export LCG

    mutable struct LcgGenerator
        state::Int
        a::Int
        p::Int
    end

    function LCG(g::LcgGenerator)
        new_state = (g.a * g.state) % g.p
        g.state = new_state
        return new_state / g.p
    end

    function LCG(;seed::Int = 2^16 - 1)
        g = LcgGenerator(seed, 7^5, 2^31 - 1)
        return LCG(g)
    end

    function LCG(g::LcgGenerator, size::Int64)
        result = zeros(size)
        for i in 1:size
            result[i] = LCG(g)
        end
        return result
    end

    function LCG(size::Int64; seed::Int = 2^16 - 1)
        g = LcgGenerator(seed, 7^5, 2^31 -1)
        return LCG(g, size)
    end

end