# LISTA 5 ZADANIE 2
using Plots
using LinearAlgebra
using HypothesisTests
using Distributions

function multivariate_normal(size :: Int, dim :: Int, covariance_matrix :: Matrix, means_vector :: Vector)

    result = Matrix{Float64}(undef, size, dim)

    A = cholesky(covariance_matrix).L
    
    for i = 1:size
        result[i, :] = A * randn(dim) + means_vector
    end

    return result

end

##############################
# Dwuwymiarowy wektor normalny
##############################

# Parametry 
σ1_2d = 1
σ2_2d = 2

ρ    = 0

μ1_2d   = 1
μ2_2d   = 3

means_vector_2d = [μ1_2d, μ2_2d]

covariance_mat_2d = [
    σ1_2d^2 σ1_2d * σ2_2d * ρ
    σ1_2d * σ2_2d * ρ σ2_2d^2
]


samples2d = multivariate_normal(1_000_000, 2, covariance_mat_2d, means_vector_2d)

# Gęstości współrzędnych
histogram(samples2d[:, 1], normalize = :pdf, label="Gęstość współrzędnej X")
histogram!(samples2d[:, 2], normalize = :pdf, label="Gęstość współrzędnej Y")

# Gęstość łączna
histogram2d(samples2d[:, 1], samples2d[:, 2], aspect_ratio = 1, normalize=:pdf)


# Testy statystyczne 

# Test Kołmogorova - Smirnoffa 
ExactOneSampleKSTest(samples2d[:, 1], Normal(0, σ1_2d))
ExactOneSampleKSTest(samples2d[:, 2], Normal(0, σ2_2d))

# Test Andersona - Darlinga
OneSampleADTest(samples2d[:, 1], Normal(0, σ1_2d))
OneSampleADTest(samples2d[:, 2], Normal(0, σ2_2d))

# Test Jarque - Bera 
JarqueBeraTest(samples2d[:, 1])
JarqueBeraTest(samples2d[:, 2])

# Test Hottelinga 
OneSampleHotellingT2Test(samples2d, means_vector_2d)



################################
# Trójwymiarowy rozkład normalny
################################

# Parametry
σ1_3d  = 1
σ2_3d  = 2
σ3_3d  = 3

ρ12 = 0.5
ρ13 = 0
ρ23 = -0.3

μ1_3d  = 0
μ2_3d  = 0
μ3_3d  = 0

means_vector_3d = [μ1_3d, μ2_3d, μ3_3d]

covariance_mat_3d = [
    σ1_3d^2  σ1_3d * σ2_3d * ρ12  σ1_3d * σ3_3d * ρ13
    σ1_3d * σ2_3d * ρ12  σ2_3d^2  σ2_3d * σ3_3d * ρ23
    σ1_3d * σ3_3d * ρ13  σ2_3d * σ3_3d * ρ23  σ3_3d^2
]

samples3d = multivariate_normal(100_000, 3, covariance_mat_3d, means_vector_3d)

# Gęstości współrzędnych
histogram(samples3d[:, 1], normalize = :pdf,  label="Gęstość współrzędnej X")
histogram!(samples3d[:, 2], normalize = :pdf, label="Gęstość współrzędnej Y")
histogram!(samples3d[:, 3], normalize = :pdf, label="Gęstość współrzędnej Z")

# Rozkład wektora
scatter(samples3d[:, 1], samples3d[:, 2], samples3d[:, 3], aspect_ratio = 1, markersize = 0.3)

# Gęstości zrzutowanego rozkładu

# Rzut na Płaszczyznę XY
histogram2d(samples3d[:, 1], samples3d[:, 2], aspect_ratio=1, normalize = :pdf)
# Rzut na płaszczyznę XZ
histogram2d(samples3d[:, 1], samples3d[:, 3], aspect_ratio=1, normalize = :pdf)
# Rzut na płaszczyznę YZ
histogram2d(samples3d[:, 2], samples3d[:, 3], aspect_ratio=1, normalize = :pdf)

# Testy statystyczne

# Test Kołmogorova - Smirnoffa 
ExactOneSampleKSTest(samples3d[:, 1], Normal(0, σ1_3d))
ExactOneSampleKSTest(samples3d[:, 2], Normal(0, σ2_3d))
ExactOneSampleKSTest(samples3d[:, 3], Normal(0, σ3_3d))

# Test Andersona - Darlinga
OneSampleADTest(samples3d[:, 1], Normal(0, σ1_3d))
OneSampleADTest(samples3d[:, 2], Normal(0, σ2_3d))
OneSampleADTest(samples3d[:, 3], Normal(0, σ3_3d))

# Test Jarque - Bera 
JarqueBeraTest(samples3d[:, 1])
JarqueBeraTest(samples3d[:, 2])
JarqueBeraTest(samples3d[:, 3])

# Test Hottelinga 
OneSampleHotellingT2Test(samples3d, means_vector_3d)