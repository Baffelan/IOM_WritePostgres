function get_baseline_dists_benchmark(base)
    # burnin_dict = NamedTuple{String, AbstractArray}(x̄=>0.0, σ=>0.0)
    distances = Vector{Float32}()
    for i in 2:length(base)
           dists = mean(abs.(base[i-1].-base[i]))
           push!(distances, dists)
    end
    return mean(distances), std(distances) 
end