# LISTA 3 ZADANIE 4 
using Distributions
using Plots
using .AcceptReject
using HypothesisTests

"""
Zwraca indeksy położeń `xs` w `intervals`
"""
function findindexes(xs, intervals)
    result = Vector{Int64}(undef, length(xs))
    for (i, x) in enumerate(xs)
        val = findfirst([min < x < max for (min, max) in intervals])
        result[i] = isnothing(val) ? length(intervals) : val
    end
    return result
end

"""
Zwraca krotkę wektorów `(intervals, extrema)` gdzie:

* `intervals` - wektor zawierający krotki (lower, upper), gdzie lower i upper to granice przedziału
* `extrema` - wektor zawierający krotki (min, max) gdzie min i max to najmniejsze i najwięskze wartości `f` na przedziale 

"""
function steps(f :: Function, xmin, xmax, ammount; sampling_density=100)
    
    intervals = Vector{Tuple{Float64, Float64}}(undef, ammount)
    extr      = Vector{Tuple{Float64, Float64}}(undef, ammount)

    step = (xmax - xmin) / ammount
    for i in 1:ammount
        lower = xmin + (i - 1) * step
        upper = lower + step
        intervals[i] = (lower, upper)
        extr[i] = extrema(f.(LinRange(lower, upper, sampling_density)))
    end

    return (intervals, extr)
end

"""
Zwraca krotkę wektorów `(intervals, extrema)` gdzie:

* `intervals` - wektor zawierający krotki `(lower, upper)`, gdzie `lower` i `upper` to granice przedziału
* `extrema` - wektor zawierający krotki `(min, max)` gdzie `min` i `max` to najmniejsze i najwięskze wartości
funkcji prawdopodobieństwa rozkładu `dist` na przedziale 

"""
function steps(dist :: Distribution, xmin, xmax, ammount; sampling_density=100)
    
    intervals = Vector{Tuple{Float64, Float64}}(undef, ammount)
    extr      = Vector{Tuple{Float64, Float64}}(undef, ammount)

    step = (xmax - xmin) / ammount
    for i in 1:ammount
        lower = xmin + (i - 1) * step
        upper = lower + step
        intervals[i] = (lower, upper)
        extr[i] = extrema(pdf.(dist, LinRange(lower, upper, sampling_density)))
    end

    return (intervals, extr)
end


"""
Usprawnienie generowania metodą akceptacji-odrucenia poprzez zastosowanie metody zigguratu 
"""
function ziggurat(sampled_dist :: Distribution, destination_dist :: Distribution, c, N; mult=1)

    samples = Vector{Float64}(undef, N)

    prev_filled_count = 0
    filled_count      = 0
    size              = N
    
    intervals, extr = steps(destination_dist, 0, 5, 1000)
    

    while filled_count < N

        x = rand(sampled_dist, size)
        # Wartość CUg(X) zapisana do pamięci w celu zmniejszenia ilości obliczeń
        Y = c .* rand(size) .* pdf.(sampled_dist, x) 

        indexes = findindexes(x, intervals)

        mask = BitArray(undef, size)
        for i in 1:size
            if Y[i] > extr[indexes[i]][1]
                mask[i] = 0
            elseif Y[i] < extr[indexes[i]][2]
                mask[i] = 1
            else 
                mask[i] = Y[i] <= mult * pdf(destination_dist, x[i])
            end
        end
        
        filled_now    = sum(mask)
        filled_count += filled_now
        size         -= filled_now

        samples[1+prev_filled_count:filled_count] = x[mask][1:filled_count-prev_filled_count]
        prev_filled_count = filled_count

    end
    samples
end

function ziggurat(sampled_dist :: Distribution, destination_pdf :: Function, c, N; mult=1)

    samples = Vector{Float64}(undef, N)
    
    prev_filled_count = 0
    filled_count      = 0
    size              = N
    
    intervals, extr = steps(destination_dist, 0, 100, 100000)
    

    while filled_count < N
        
        x = rand(sampled_dist, size)
        
        Y = c .* rand(size) .* pdf.(sampled_dist, x) 

        indexes = findindexes(x, intervals)

        mask = BitArray(undef, size)
        for i in 1:size
            if Y[i] > extr[indexes[i]][1]
                mask[i] = 0
            elseif Y[i] < extr[indexes[i]][2]
                mask[i] = 1
            else 
                mask[i] = Y[i] <= mult * destination_pdf(x[i])
            end
        end
        
        filled_now    = sum(mask)
        filled_count += filled_now
        size         -= filled_now

        samples[1+prev_filled_count:filled_count] = x[mask][1:filled_count-prev_filled_count]
        prev_filled_count = filled_count

    end
    samples
end


samples = ziggurat(Exponential(1), Normal(0, 1), sqrt(2ℯ/π), 1_000_0; mult=2)
samples = vcat(samples, -1 .* samples)
ExactOneSampleKSTest(samples, Normal(0, 1))
histogram(samples, normalize=:pdf, label=false)