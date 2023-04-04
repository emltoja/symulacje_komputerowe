using Plots 

function corput(size::Int, base::Int)

    arr = round.(Int64, LinRange(1, size, size))
    new_base_nums = reverse.(string.(arr, base=base))
    denoms = base.^length.(new_base_nums)
    base_10_nums = parse.(Int, new_base_nums, base=base)
    result = base_10_nums ./ denoms


    return result

end

print(corput(100, 7))
scatter(LinRange(1, 1000, 1000), corput(1000, 31), markersize=3)