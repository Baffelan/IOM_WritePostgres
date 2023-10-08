function alternating_noisy_seq(rdpg, seq_len, noise; rand_func=randomise_sample_switchvalue)
    graphs = resample_rdpg(rdpg,seq_len)
    make_noisy = false
    for i in eachindex(graphs)
        if make_noisy
            graphs[i] = rand_func(graphs[i], noise)
        end
        make_noisy = !make_noisy
    end
    return graphs
end

