using JSON
using DataFrames
using Dates

include("WordNetwork/WordNetwork.jl")
# include("importedFunctions/WordNetwork/articles_to_word_network.jl")
include("ReadWritePostgres.jl")
include("anomalyDetection.jl")
include("importedFunctions/kw_data_frame.jl")
# include("importedFunctions/Analysis/word_count.jl")
include("importedFunctions/CreateProcessedDf.jl")
include("get_baseline_df.jl")

"""
processes the previous day's news articles into the processed table schema
"""
function process_todays_articles(userID)
    conf = JSON.parsefile("config.json")
    ALIGNMENT_TOKENS = conf["ALIGNMENT_TOKENS"][1:3]
    DAY_RANGE = Date.(conf["DAY_RANGE"])
    BURNIN_RANGE = Date.(conf["BURNIN_RANGE"])
    EMBEDDING_DIM = conf["EMBEDDING_DIM"]

    user_agg = string(userID,"_aggregated")

    df = query_postgres("raw", "back", condition=string("WHERE lang='eng' ", 
                                                        "AND user_ID='",userID,"'",
                                                        "AND date<='",DAY_RANGE[2],"' ",
                                                        "AND DATE >= '",DAY_RANGE[1],"'"))
    #split_on_day(df) = [df[df[!,:date].==d,:] for d in unique(df[!,:date])]

    kws = rsplit(df.keywords[1][2:end-1],",")[1:10]
    
    kw_dfs = kw_data_frame.(kws, [df])
    kw_dict = Dict(zip(kws, kw_dfs))

    kw_dict[user_agg] = df
    
    # baseline_df = get_baseline_df(userID, (BURNIN_RANGE[1],BURNIN_RANGE[2]))

    # refmatrix = subembedding_from_tokens(burnin_ws[user_agg][1], ALIGNMENT_TOKENS, aligned=true)

    ks = keys(kw_dict)

    # base_dist = [get_baseline_dists_day(baseline_df[k]) for k in ks]

    analysed = create_processed_df.(values(kw_dict), ks, [ALIGNMENT_TOKENS], [[1.0 0.0; 0.0 1.0; 0.0 1.0]], [2], [[0.0, 1.0]])#[refmatrix], [2], dase_dist)


    all_dates = unique(kw_dict[user_agg].date)

    fill_blank_dates!(df, dates) = df.date=dates
    fill_blank_dates!.(analysed,[all_dates])

    big_df = vcat(analysed...)
    big_df.user_ID .= userID


    sort!(big_df, :date)


    load_processed_data(big_df[big_df.date .== DAY_RANGE[2],:])
    return big_df[big_df.date .== DAY_RANGE[2],:]
end
# userID=999
# process_todays_articles(999)