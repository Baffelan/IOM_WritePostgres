#  include("WordNetwork/WordNetwork.jl")

# function make_to_wn(proc_df_row)
#     token_idx  = JSON.parse(proc_df_row.token_idx)
#     embedding = proc_df_row.embedding
#     aligning_matrix = proc_df_row.aligning_matrix
#     wn = WordNetwork(Matrix{Bool}(undef,0,0), (L̂=embedding[:,:]',R̂=Matrix{Float64}(undef, 0,0)), token_idx, aligning_matrix[:,:]')
# end

# make_wns(proc_df) = make_to_wn.(eachrow(proc_df))




