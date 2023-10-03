DATE=Date("2023-09-01")

include("utils/get_base_rdpg.jl")
include("utils/resample_rdpg.jl")
include("utils/randomise_sample.jl")
include("utils/get_baseline_dists_benchmark.jl")


rdpg = get_base_rdpg()
baseline = resample_rdpg(rdpg,30)
test = resample_rdpg(rdpg,5)

test[4] = randomise_sample(test[4], 250)

get_L(E) = E[:L̂]
func(V) = word_network_self_dist.(get_L.(V))

@time base = DotProductGraphs.svd_embedding.(baseline, [fast_svd], [4])
base = func(base)

@time t = DotProductGraphs.svd_embedding.(test, [fast_svd], [4])
t = func(t)

t[4] = word_network_self_dist(DotProductGraphs.svd_embedding(test[4], fast_svd, 4)[:L̂])


m, s = get_baseline_dists_benchmark(base)

distances = Vector{Float32}()
for i in 2:length(t)
       dists = mean(abs.(t[i-1].-t[i]))
       push!(distances, dists)
end

threshold = 3
abs.(distances.-m).>threshold*s
