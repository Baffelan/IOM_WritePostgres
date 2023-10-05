date=Date("2023-10-01") # Date we are taking for our RDPG
threshold = 3 # Number of std difference from baseline to be qualified as anomally
noise = 200 # Number of edges set to 0 as well as number of edges set to one
baseline_samples = 30 # Number of samples in baseline (can take a while to do embedding so don't make too big)

include("utils/get_base_rdpg.jl")
include("utils/resample_rdpg.jl")
include("utils/randomise_sample.jl")
include("utils/get_baseline_dists_benchmark.jl")


rdpg = get_base_rdpg(date)
baseline = resample_rdpg(rdpg,51)

get_L(E) = E[:L̂]
func(V) = word_network_self_dist.(get_L.(V))

@time m, s = get_baseline_dists_benchmark(func(DotProductGraphs.svd_embedding.(baseline, [fast_svd], [4])))

test = resample_rdpg(rdpg,5)
test[4] = randomise_sample(test[4], noise)

@time t = func(DotProductGraphs.svd_embedding.(test, [fast_svd], [4]))



distances = Vector{Float32}()
for i in 2:length(t)
       dists = mean(abs.(t[i-1].-t[i]))
       push!(distances, dists)
end

threshold = 4
abs.(distances.-m)./s
