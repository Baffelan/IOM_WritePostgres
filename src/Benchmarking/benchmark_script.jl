date=Date("2023-10-01") # Date we are taking for our RDPG
threshold = 3 # Number of std difference from baseline to be qualified as anomally
noise = 200 # Number of edges set to 0 as well as number of edges set to one
seq_len = 51 # Number of samples in baseline (can take a while to do embedding so don't make too big)
kw = "musk"

include("utils/get_base_rdpg.jl")
include("utils/resample_rdpg.jl")
include("utils/randomise_sample.jl")
include("utils/mean_word_distance_seq.jl")
include("utils/embedding.jl")
include("noisy_rdpg_dist.jl")

rdpg = get_base_rdpg(date, kw)

noise_levels = [0, 0.02, 0.04, 0.06, 0.08, 0.10, 0.12]

distributions = []
for noise in noise_levels
       dist = noisy_rdpg_distribution(rdpg, seq_len, noise)
       push!(distributions, dist)
end

avg = [d[1] for d in distributions]
e = [d[2] for d in distributions]

using PlotlyJS
trace= scatter(
       x=100 .*noise_levels, y=avg,
       mode="markers",
       error_y=attr(type="data", array=3 .*e)
      )

layout = Layout(
    title=attr(
        text= "Mean Word Distances vs Network Noise ($(kw))",
        y=0.9,
        x=0.5,
        xanchor= "center",
        yanchor= "top"
    ),
    xaxis_title= "noise (% of network size)",
    yaxis_title= "mean word distance"
)

PlotlyJS.plot(trace, layout)

# baseline = resample_rdpg(rdpg,51)

# get_L(E) = E[:L̂]
# func(V) = word_network_self_dist.(get_L.(V))

# @time m, s = get_baseline_dists_benchmark(func(DotProductGraphs.svd_embedding.(baseline, [fast_svd], [4])))

# test = resample_rdpg(rdpg,5)
# test[4] = randomise_sample(test[4], noise)

# @time t = func(DotProductGraphs.svd_embedding.(test, [fast_svd], [4]))



# distances = Vector{Float32}()
# for i in 2:length(t)
#        dists = mean(abs.(t[i-1].-t[i]))
#        push!(distances, dists)
# end

# threshold = 4
# abs.(distances.-m)./s
