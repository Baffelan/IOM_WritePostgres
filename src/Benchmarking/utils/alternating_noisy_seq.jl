function alternating_noisy_seq(rdpg, seq_len, noise)
    graphs = resample_rdpg(rdpg,seq_len)
    make_noisy = false
    for i in eachindex(graphs)
        if make_noisy
            graphs[i] = randomise_sample(graphs[i], noise)
        end
        make_noisy = !make_noisy
    end
    return graphs
end

