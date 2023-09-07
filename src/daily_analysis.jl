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
include("get_burnin_wns.jl")

"""
Collects the previous day's news articles into the newsapi table and then processes them into the processed table
"""
function daily_analysis(userID)
    user = user_from_id(userID)
    user_agg = string(user[:id],"_aggregated")
    ALIGNMENT_TOKENS = ("the", "of", "to", "and", "in", "is", "that", "have", "it", "for", "on")

    day_diff = Day(10)

    df = query_postgres("newsapi", condition=string("WHERE lang='eng' AND date<='",today()-day_diff,"' AND DATE >= '", today()-day_diff-Day(1),"'"))

    split_on_day(df) = [df[df[!,:date].==d,:] for d in unique(df[!,:date])]

    kw_dfs = kw_data_frame.(user[:keywords], [df])
    kw_dict = Dict(zip(user[:keywords], split_on_day.(kw_dfs)))

    kw_dict[user_agg] = split_on_day(df)
    
    burnin_ws = get_burnin_wns(user)
    refmatrix = subembedding_from_tokens(burnin_ws[user_agg][1], ALIGNMENT_TOKENS, aligned=true)

    ks = keys(kw_dict)

    burnin_trace = [burnin_ws[k] for k in ks]

    analysed = create_processed_df.(values(kw_dict), ks, [ALIGNMENT_TOKENS], [refmatrix], [2], [1:100], burnin_trace)


    # all_dates = [unique(df.date)[1] for df in kw_dict["aggregated"]]

    # fill_blank_dates!.(analysed,[all_dates])

    # big_df = vcat(analysed...)

    # sort!(big_df, :date)

    # load_processed_data(big_df)

end



daily_analysis("001")


# arts = py"e"(user)
