"""
gets the user's information from the forward facing db.
Collects a large amount of information in the burnin period and processes is to the back facing db.

"""
function process_articles(userID, day_range::Vector{Date}, calc_distribution::Bool, alignment_tokens, burnin_range, embedding_dim)
    # conf = JSON.parsefile("config.json")
    # ALIGNMENT_TOKENS = conf["ALIGNMENT_TOKENS"]
    # BURNIN_RANGE = Date.(conf["BURNIN_RANGE"])
    # EMBEDDING_DIM = conf["EMBEDDING_DIM"]

    user_agg = string(userID,"_aggregated")
    old_df = query_postgres("processedarticles", "back", condition=string("WHERE user_ID='",userID,"'", "AND date='",day_range[2],"'"))
    df = query_postgres("raw", "back", condition=string("WHERE lang='eng' ",
                                                        "AND user_ID='",userID,"'",
                                                        "AND date<='",day_range[2],"' ",
                                                        "AND DATE >= '",day_range[1],"'"))

    kw_dataframes, kws, base_dist, refmatrix = set_up_inputs(df, burnin_range, user_agg, alignment_tokens, calc_distribution)

    if !calc_distribution
        base_dist = [base_dist,]
        refmatrix = diagm(length(alignment_tokens), embedding_dim, ones(Float64, embedding_dim))
    end

    analysed = create_processed_df.(kw_dataframes, kws, [alignment_tokens], [refmatrix], [embedding_dim], base_dist, [day_range]) # indexing on kw_df and kw needs to go

    # all_dates = unique(kw_dict[user_agg].date)
    big_df = vcat(analysed...)
    big_df.user_ID .= userID

    sort!(big_df, :date)

    #load_processed_data(big_df[big_df.date .== today()-Day(1),:])
    return big_df
    
end
# userID=999
# onboarded = process_articles(999, [Date("2023-08-01"),Date("2023-09-01")], false)
# load_processed_data(onboarded)


