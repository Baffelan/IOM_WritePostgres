using IOM_WritePostgres
using Test

using DataFrames

embs = [[1 0; 0 1; 0 2], [0 1; 1 1; 2 1]]
idxs = [Dict("is"=>1, "was"=>2, "were"=>3), Dict("has"=>1, "will"=>2, "is"=>3)]
df = DataFrame(embedding=embs, token_idx=idxs)

targets = (Float32[1.0 0.0; 0.0 1.0; 1.0 2.0; 0.0 0.0; 0.0 0.0], Float32[2.0 1.0; 0.0 0.0; 0.0 0.0; 0.0 1.0; 1.0 1.0], ["is", "was", "were", "has", "will"])

@testset "IOM_WritePostgres.jl" begin
    @test targets == IOM_WritePostgres.create_interacting_embedding(df[1,:], df[2,:])

end
