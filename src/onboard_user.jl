
"""
gets the user's information from the forward facing db.
Collects a large amount of information in the burnin period and processes is to the back facing db.

"""
function onboard_user(userID)
    conf = JSON.parsefile("config.json")
    ALIGNMENT_TOKENS = conf["ALIGNMENT_TOKENS"]
    DAY_RANGE = conf["DAY_RANGE"]
    BURNIN_RANGE = Date.(conf["BURNIN_RANGE"])
    EMBEDDING_DIM = conf["EMBEDDING_DIM"]


    user_agg = string(userID,"_aggregated")

    df = query_postgres("raw", "back", condition=string("WHERE lang='eng' ", 
                                                        "AND user_ID=",userID," ",
                                                        "AND date<='",BURNIN_RANGE[2],"' ",
                                                        "AND date >= '",BURNIN_RANGE[1],"'"))

    #########
    split_on_day(df) = [df[df[!,:date].==d,:] for d in unique(df[!,:date])]

    kws = rsplit(df.keywords[1][2:end-1],",")
    
    kw_dfs = kw_data_frame.(kws, [df])
    kw_dict = Dict(zip(kws, split_on_day.(kw_dfs)))

    kw_dict[user_agg] = split_on_day(df)
    
    # burnin_ws = get_burnin_wns(userID, (BURNIN_RANGE[1],BURNIN_RANGE[1]))
    refmatrix = get_ref_matrix(kw_dict[user_agg][1], ALIGNMENT_TOKENS, EMBEDDING_DIM)

    ks = keys(kw_dict)

    # burnin_trace = [burnin_ws[k] for k in ks]

    analysed = create_processed_df.(values(kw_dict), ks, [ALIGNMENT_TOKENS], [refmatrix], [2], [1:1], [[]])


    all_dates = [unique(df.date)[1] for df in kw_dict[user_agg]]

    fill_blank_dates!.(analysed,[all_dates])

    big_df = vcat(analysed...)
    big_df.user_ID .= userID
    sort!(big_df, :date)


    load_processed_data(big_df)
end

