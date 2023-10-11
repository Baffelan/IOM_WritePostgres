"""
Generates and returns a sample sequence from the given RDPG.

# Arguments
- `rdpg::AbstractMatrix`: the random dot product graph that is resampled to generate sample sequence.
- `seq_len::Int`: the required length of the sample sequence,
- `noise::AbstractFloat`: a noise value used as input for the rand_func.
- `rand_func::Function`: function that takes a `graph` and `noise` and returns a randomised sample.

"""
function alternating_noisy_seq(rdpg::AbstractMatrix, seq_len, noise; rand_func=randomise_sample_switchvalue)
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

