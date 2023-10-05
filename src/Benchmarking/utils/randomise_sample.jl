using Random
function randomise_sample(X, noise)
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
