include("utils/alternating_noisy_seq.jl")

"""
Creates a sequence of networks sampled from `rdpg`. Every second network is randomised with proportion `noise`.

# Arguments
- `rdpg::AbstractMatrix`: The RDPG being sampled from.
- `seq_len::Int`: the length of the sequence.
- `noise::AbstractFloat`: The proportion of edges being randomised.
- `emb_dim::Int`: The dimension of the embedding for determining distances.
"""
function noisy_rdpg_distribution(rdpg::AbstractMatrix, seq_len::Int, noise::AbstractFloat; emb_dim=4, rand_func=randomise_sample_switchvalue)
    graphs = alternating_noisy_seq(rdpg, seq_len, noise,rand_func=rand_func)
    embeddings = embedding.(graphs, [emb_dim])
    distances = mean_word_distance_seq(embeddings)

    return mean(distances), std(distances)
end