function mean_word_distance_seq(embeddings)
    # burnin_dict = NamedTuple{String, AbstractArray}(x̄=>0.0, σ=>0.0)
    self_dists = word_network_self_dist.(embeddings)
    distances = Vector{Float32}()
    for i in 2:length(self_dists)
           dists = mean(abs.(self_dists[i-1].-self_dists[i]))
           push!(distances, dists)
    end
    return distances
end