using Random
"""
Randomly selects a portion of the network `X`, and sets the value to 1. Then selects another portion (of the same size and with no overlap) and sets it to 0.

# Arguments
- `X::AbstractMatrix{Int}`: The network to be randomised.
- `noise::AbstractFloat`: The proportion of edges being randomised (note that twice the proportion will be updated in this case).
"""
function randomise_sample_setvalue(X::AbstractMatrix{Int}, noise::AbstractFloat)
    num_replaced = convert(Int, round(noise*size(X)[1]))
    A = X
    s1 = randperm(size(X)[1])
    s2 = randperm(size(X)[2])
    A[s1[1:num_replaced],s2[1:num_replaced]] .=0
    A[s2[1:num_replaced],s1[1:num_replaced]] .=0
    A[s1[1+num_replaced:2*num_replaced],s2[1+num_replaced:2*num_replaced]] .=0
    A[s2[1+num_replaced:2*num_replaced],s1[1+num_replaced:2*num_replaced]] .=0
    A
end

"""
Randomly selects a portion of the network `X`, and updates the value with a Bernoulli(0.5) distribution.

# Arguments
- `X::AbstractMatrix{Int}`: The network to be randomised.
- `noise::AbstractFloat`: The proportion of edges being randomised.
"""
function randomise_sample_switchvalue(X::AbstractMatrix{Int}, noise::AbstractFloat)
    num_replaced = convert(Int, round(noise*size(X)[1]*size(X)[2]))
    A = copy(X)
    idx = [(rand(1:size(X)[1]),rand(1:size(X)[1])) for _ in 1:num_replaced]
    #s2 = randperm(size(X)[2])[1:num_replaced]
    switch_1_0(x) = 1.0-x*1.0
    for (i,j) in idx
        new_val = rand(Bernoulli(0.5))# Hard coded probability of 0.5
        A[i,j] =switch_1_0.(A[i,j])
        A[j,i] =switch_1_0.(A[j,i])
    end
    return A
end

