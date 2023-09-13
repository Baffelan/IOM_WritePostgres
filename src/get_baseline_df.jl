#  include("WordNetwork/WordNetwork.jl")

# function make_to_wn(proc_df_row)
#     token_idx  = JSON.parse(proc_df_row.token_idx)
#     embedding = proc_df_row.embedding
#     aligning_matrix = proc_df_row.aligning_matrix
#     wn = WordNetwork(Matrix{Bool}(undef,0,0), (L̂=embedding[:,:]',R̂=Matrix{Float64}(undef, 0,0)), token_idx, aligning_matrix[:,:]')
# end

# make_wns(proc_df) = make_to_wn.(eachrow(proc_df))


function get_baseline_df(userID, burnin::Tuple{Date, Date})
    df = query_postgres("processedarticles", "back", condition = string("WHERE user_ID='",userID,"'",
                                                                        "AND date<='",burnin[2],"' ",
                                                                        "AND DATE >= '",burnin[1],"'"))

    if nrow(df)==0
        println("A baseline has not been processed for this user.")
        println("Please onboard them with the function: [onboard_user]")        
    end

    all_kws = unique(df.keyword)
    kw_dfs = [df[df.keyword.==w,:] for w in all_kws]
end

