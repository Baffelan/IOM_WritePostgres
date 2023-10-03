using Random
function randomise_sample(X, noise)
    A = X
    s1 = randperm(size(X)[1])
    s2 = randperm(size(X)[2])
    A[s1[1:noise],s2[1:noise]] .=0
    A[s2[1:noise],s1[1:noise]] .=0
    A[s1[1+noise:2*noise],s2[1+noise:2*noise]] .=0
    A[s2[1+noise:2*noise],s1[1+noise:2*noise]] .=0
    A
end