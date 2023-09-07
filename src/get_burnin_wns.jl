include("WordNetwork/WordNetwork.jl")

function make_to_wn(proc_df_row)
    token_idx  = JSON.parse(proc_df_row.token_idx)
    embedding = proc_df_row.embedding
    aligning_matrix = proc_df_row.aligning_matrix
    wn = WordNetwork(Matrix{Bool}(undef,0,0), (L̂=embedding[:,:]',R̂=Matrix{Float64}(undef, 0,0)), token_idx, aligning_matrix[:,:]')
end

make_wns(proc_df) = make_to_wn.(eachrow(proc_df))


function get_burnin_wns(user)
    all_kws = Tuple(vcat(user[:keywords]..., string(user[:id],"_aggregated")))

    # all_kws = Tuple(vcat(user[:keywords]..., string("aggregated"))),
    df = query_postgres("processedarticles", condition=string(replace(string("WHERE keyword IN ",all_kws),"\""=>"'"), "ORDER BY date DESC LIMIT $(length(all_kws)*100)"),test=false)

    kw_dfs = [df[df.keyword.==w,:] for w in all_kws]
    

    wnss = make_wns.(kw_dfs)
    wnss_dict = Dict(zip(all_kws, wnss))
end

