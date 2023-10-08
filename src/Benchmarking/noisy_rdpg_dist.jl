include("utils/alternating_noisy_seq.jl")

function noisy_rdpg_distribution(rdpg, seq_len, noise; emb_dim=4, rand_func=randomise_sample_switchvalue)
    graphs = alternating_noisy_seq(rdpg, seq_len, noise,rand_func=rand_func)
    embeddings = embedding.(graphs, [emb_dim])
    distances = mean_word_distance_seq(embeddings)

    return mean(distances), std(distances)
end