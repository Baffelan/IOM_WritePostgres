

"""
processes the previous day's news articles into the processed table schema
"""
function process_todays_articles(userID)
    conf = JSON.parsefile("config.json")
    ALIGNMENT_TOKENS = conf["ALIGNMENT_TOKENS"]
    BURNIN_RANGE = Date.(conf["BURNIN_RANGE"])
    EMBEDDING_DIM = conf["EMBEDDING_DIM"]

    user_agg = string(userID,"_aggregated")

    df = query_postgres("raw", "back", condition=string("WHERE lang='eng' ",
                                                        "AND user_ID='",userID,"'",
                                                        "AND date<='",today()-Day(1),"' ",
                                                        "AND DATE >= '",today()-Day(1),"'"))
    #split_on_day(df) = [df[df[!,:date].==d,:] for d in unique(df[!,:date])]

    kws = rsplit(df.keywords[1][2:end-1],",")

    kw_dfs = kw_data_frame.(kws, [df])
    kw_dict = Dict(zip(kws, kw_dfs))

    kw_dict[user_agg] = df

    baseline_df = get_baseline_df(userID, (BURNIN_RANGE[1],BURNIN_RANGE[2]))
    base_dict = Dict([df.keyword[1]=>df for df in baseline_df]...)

    refmatrix = hcat(sub_index(base_dict[user_agg][1,:embedding], sub_index(JSON.parse(base_dict[user_agg][1,:token_idx]), ALIGNMENT_TOKENS))...)

    ks = [k for k in keys(kw_dict) if k in keys(base_dict)]
    vs = [v for (k,v) in pairs(kw_dict) if k in keys(base_dict)]

    base_dist = [get_baseline_dists_day(base_dict[k]) for k in ks if k in keys(base_dict)]

    analysed = create_processed_df.(vs, ks, [ALIGNMENT_TOKENS], [refmatrix], [2], base_dist)


    all_dates = unique(kw_dict[user_agg].date)

    # fill_blank_dates!(df, dates) = df.date=dates
    # fill_blank_dates!.(analysed,[all_dates])

    big_df = vcat(analysed...)
    big_df.user_ID .= userID


    sort!(big_df, :date)


    load_processed_data(big_df[big_df.date .== DAY_RANGE[2],:])
    return big_df[big_df.date .== DAY_RANGE[2],:]
end
