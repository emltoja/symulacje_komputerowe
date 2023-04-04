
module AcceptReject
    
    using Distributions

    export accept_reject

    function accept_reject(sampled_dist :: Distribution, destination_dist :: Distribution, c, N; mult=1)

        samples = Vector{Float64}(undef, N)
        prev_filled_count = 0
        filled_count = 0
        size = N

        while filled_count < N
            x = rand(sampled_dist, size)
            mask = c .* rand(size) .* pdf.(sampled_dist, x) .<= mult .* pdf.(destination_dist, x)
            filled_now = sum(mask)
            filled_count += filled_now
            size -= filled_now
            samples[1+prev_filled_count:filled_count] = x[mask][1:filled_count-prev_filled_count]
            prev_filled_count = filled_count
        end
        samples
    end

    function accept_reject(sampled_dist :: Distribution, destination_pdf :: Function, c, N; mult=1)

        samples = Vector{Float64}(undef, N)
        prev_filled_count = 0
        filled_count = 0
        size = N


        while filled_count < N
            x = rand(sampled_dist, size)
            mask = c .* rand(size) .* pdf.(sampled_dist, x) .<= mult .* destination_pdf.(x)
            filled_now = sum(mask)
            filled_count += filled_now
            size -= filled_now
            samples[1+prev_filled_count:filled_count] = x[mask][1:filled_count-prev_filled_count]
            prev_filled_count = filled_count
        end
        samples
    end

end