using Distributions
function resample_rdpg(rdpg, n)
    B = Bernoulli.(rdpg)
    [Float32.(Symmetric(rand.(B))) for _ in 1:n]
end