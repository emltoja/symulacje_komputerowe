# Moduł zawierający funkcję do generowania i 
# wizualizowania procesów poissona 

module PoissonProcess

    export nhpp, nhpp_invcdf, get_nt, get_nt_invcdf
    using Distributions

    # Niejednorodny proces poissona 
    function nhpp(T, lambda)

        time = 0
        time_intervals = Float64[]
        max_lambda = maximum(lambda, 0:0.01:T)

        while true

            t = rand(Exponential(1/lambda(time)))
            u = rand()

            # Metoda akceptacji odrzucenia
            while u >= lambda(time) / max_lambda
                t = rand(Exponential(1/lambda(time)))
                u = rand()
            end

            time += t 
            
            if time < T 
                push!(time_intervals, time)
            else 
                return time_intervals
            end

        end

    end

    # Metoda odwrotnej dystrybuanty
    function inverse_cdf(cdf, step)

        u = rand()
        x = 0

        while u > cdf(x)
            x += step
        end

        return x

    end


    # Generowanie niejednorodnego procesu Poissona 
    # z zastosowaniem metody odwrotnej dystrybuanty
    function nhpp_invcdf(T, m)

        N = rand(Poisson(m(T)))
        times = Vector{Float64}(undef, N)

        # Dystrybuanta
        cdf(t) = m(t) / m(T)

        for i in 1:N
            times[i] = inverse_cdf(cdf, 0.001)
        end

        return sort(times) 

    end

   
    # Liczba zgłoszeń do czasu t 
    function get_nt(t, T, lambda)

        n = 0
        time = 0.01
        max_lambda = maximum(lambda, time:0.01:T)

        while time < t
            
            tm = rand(Exponential(1/lambda(time)))
            u = rand()

            # Metoda akceptacji odrzucenia
            while u * max_lambda > lambda(time)
                tm = rand(Exponential(1/lambda(time)))
                u = rand()
            end
            time += tm
            
            n += 1
        end

        return n - 1

    end

    # Liczba zgłoszeń do czasu t metodą odwrotnej dystrybuanty
    function get_nt_invcdf(t, T, m)

        times = nhpp_invcdf(T, m)
        return findfirst(x -> x > t, times) - 1

    end

end