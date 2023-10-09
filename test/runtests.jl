using IOM_WritePostgres
using Test

using DataFrames

embs = [[1.0 0.0; 0.0 1.0; 1.0 2.0], [0.0 1.0; 1.0 1.0; 2.0 1.0]]
idxs = [Dict("is"=>1, "was"=>2, "were"=>3), Dict("has"=>1, "will"=>2, "is"=>3)]
df = DataFrame(embedding=embs, token_idx=idxs)

interacting_targets = (Float32[1.0 0.0; 0.0 1.0; 1.0 2.0; 0.0 0.0; 0.0 0.0], Float32[2.0 1.0; 0.0 0.0; 0.0 0.0; 0.0 1.0; 1.0 1.0], ["is", "was", "were", "has", "will"])


W = IOM_WritePostgres.WordNetwork(zeros(Float32, (1,1)), (L̂=embs[1],R̂=embs[2]),idxs[1], nothing)
transformer = [0.0 1.0; 1.0 0.0]
ref = embs[1]*transformer

@testset "IOM_WritePostgres.jl" begin
    @test interacting_targets == IOM_WritePostgres.create_interacting_embedding(df[1,:], df[2,:])
    @test isapprox(transformer, IOM_WritePostgres.aligning_matrix!(W, A=ref, tokens=collect(keys(idxs[1]))), rtol=1e-5)
end
