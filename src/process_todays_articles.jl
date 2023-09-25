

"""
processes the previous day's news articles into the processed table schema
"""
function process_todays_articles(userID::Int)
    conf = JSON.parsefile("config.json")
    ALIGNMENT_TOKENS = conf["ALIGNMENT_TOKENS"]
    BURNIN_RANGE = Date.(conf["BURNIN_RANGE"])
    EMBEDDING_DIM = conf["EMBEDDING_DIM"]

    user_agg = string(userID,"_aggregated")
    #day_range = [today()-Day(1),today()-Day(0)]

    old_df = query_postgres("processedarticles", "back", condition=string("WHERE user_ID='",userID,"'", "AND date='",day_range[2],"'"))
    df = query_postgres("raw", "back", condition=string("WHERE lang='eng' ",
                                                        "AND user_ID='",userID,"'",
                                                        "AND date<='",day_range[2],"' ",
                                                        "AND DATE >= '",day_range[1],"'"))

    kw_dataframes, kws, base_dist, refmatrix = set_up_inputs(df, BURNIN_RANGE, user_agg, ALIGNMENT_TOKENS)
    analysed = create_processed_df.(kw_dataframes, kws, [ALIGNMENT_TOKENS], [refmatrix], [EMBEDDING_DIM], base_dist, [day_range]) # indexing on kw_df and kw needs to go

    # all_dates = unique(kw_dict[user_agg].date)
    big_df = vcat(analysed...)
    big_df.user_ID .= userID

    sort!(big_df, :date)

    load_processed_data(big_df[big_df.date .== today()-Day(1),:])
    return big_df[big_df.date .== today()-Day(1),:]
end


