"""
Samples an RDPG `n` times and returns them as a sequence.

# Arguments
- `rdpg::AbstractMatrix`: An RDPG (likely generated from an embedding).
- `n::Int`: Number of samples required.
"""
function sample_rdpg(rdpg, n)
    B = Bernoulli.(rdpg)
    [Float32.(Symmetric(rand.(B))) for _ in 1:n]
end