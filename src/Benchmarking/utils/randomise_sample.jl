using Random
function randomise_sample_setvalue(X, noise)
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


function randomise_sample_switchvalue(X, noise)
    num_replaced = convert(Int, round(noise*size(X)[1]*size(X)[2]))
    A = copy(X)
    idx = [(rand(1:size(X)[1]),rand(1:size(X)[1])) for _ in 1:num_replaced]
    #s2 = randperm(size(X)[2])[1:num_replaced]
    switch_1_0(x) = 1.0-x*1.0
    for (i,j) in idx
        new_val = rand(Bernoulli(0.5))
        A[i,j] =switch_1_0.(A[i,j])
        A[j,i] =switch_1_0.(A[j,i])
    end
    return A
end

rand(1:10)