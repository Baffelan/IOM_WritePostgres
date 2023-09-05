using JSON
using DataFrames
using Dates

# include("importedFunctions/WordNetwork/WordNetwork.jl")
# include("importedFunctions/WordNetwork/articles_to_word_network.jl")
# include("importedFunctions/postgreSQL/ReadWritePostgres.jl")
# include("importedFunctions/Analysis/Anomaly/anomalyDetection.jl")
include("importedFunctions/kw_data_frame.jl")
# include("importedFunctions/Analysis/word_count.jl")
# include("importedFunctions/Analysis/CreateProcessedDf.jl")


"""
Collects the previous day's news articles into the newsapi table and then processes them into the processed table
"""
function daily_analysis(userID)
    user = user_from_id(userID)

    ALIGNMENT_TOKENS = ("the", "of", "to", "and", "in", "is", "that", "have", "it", "for", "on")

    df = query_postgres("newsapi", condition=string("WHERE lang='eng' AND date='",today()-Day(10),"'"))



    kw_dfs = kw_data_frame.(user[:keywords], [df])
    kw_dict = Dict(zip(user[:keywords], kw_dfs))

    kw_dict["aggregated"] = df

    kw_dict

    # refmatrix = get_ref_matrix(kw_dict["aggregated"][1], ALIGNMENT_TOKENS, 2)

    # ks = keys(kw_dict)
    # analysed = create_processed_df.(values(kw_dict), ks, [ALIGNMENT_TOKENS], [refmatrix], [2], [1:100])


    # all_dates = [unique(df.date)[1] for df in kw_dict["aggregated"]]

    # fill_blank_dates!.(analysed,[all_dates])

    # big_df = vcat(analysed...)

    # sort!(big_df, :date)

    # load_processed_data(big_df)

end






# arts = py"e"(user)
