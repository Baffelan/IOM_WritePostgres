"""
Calculates the average word distance for each day and returns a vector sequence of average daily distances.
    
# Arguments
- `embeddings::Vector{AbstractMatrix}`: vector of embeddings.
"""
function mean_word_distance_seq(embeddings::Vector{AbstractMatrix})
    self_dists = word_network_self_dist.(embeddings)
    distances = Vector{Float32}()
    for i in 2:length(self_dists)
           dists = mean(abs.(self_dists[i-1].-self_dists[i]))
           push!(distances, dists)
    end
    return distances
end