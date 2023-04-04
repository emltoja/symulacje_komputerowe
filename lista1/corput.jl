module Corput
    export corput

    function corput(size::Int, base::Int)

        arr = round.(Int64, LinRange(1, size, size))
        new_base_nums = reverse.(string.(arr, base=base))
        denoms = base.^length.(new_base_nums)
        base_10_nums = parse.(Int, new_base_nums, base=base)
        result = base_10_nums ./ denoms
    
    
        return result
    
    end

end

