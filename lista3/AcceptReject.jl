"""Moduł zawierający funkcje do generowania zmiennych losowych metodą akceptacji-odrzucenia"""
module AcceptReject
    
    using Distributions
    export accept_reject


    """
    Generuje liczby z rozkładu `destination_dist` metodą akceptacji-odrzucenia.
    """
    function accept_reject(sampled_dist :: Distribution, destination_dist :: Distribution, c, N; mult=1)

        samples = Vector{Float64}(undef, N)

        prev_filled_count = 0
        filled_count      = 0
        size              = N

        while filled_count < N
            
            x = rand(sampled_dist, size)
            # mult = 2 do generowania rozkładu |N(0, 1)| z rozkładu N(0, 1). W innym przypadku mult = 1. 
            mask = c .* rand(size) .* pdf.(sampled_dist, x) .<= mult .* pdf.(destination_dist, x)
            
            filled_now    = sum(mask)
            filled_count += filled_now
            size         -= filled_now
            
            samples[1+prev_filled_count:filled_count] = x[mask][1:filled_count-prev_filled_count]
            prev_filled_count = filled_count
        
        end
        
        return samples
    
    end


    """
    Generuje liczby z rozkładu o funkcji gęstości `destination_pdf` metodą akceptacji-odrzucenia.
    """
    function accept_reject(sampled_dist :: Distribution, destination_pdf :: Function, c, N; mult=1)

        samples = Vector{Float64}(undef, N)

        prev_filled_count = 0
        filled_count      = 0
        size              = N

        while filled_count < N
        
            x = rand(sampled_dist, size)
            
            # Wektor wskazujący na elementy do zaakceptowania 
            mask = c .* rand(size) .* pdf.(sampled_dist, x) .<= mult .* destination_pdf.(x)

            filled_now    = sum(mask)
            filled_count += filled_now
            size         -= filled_now


            samples[1+prev_filled_count:filled_count] = x[mask][1:filled_count-prev_filled_count]
            prev_filled_count = filled_count

        end

        return samples

    end

end