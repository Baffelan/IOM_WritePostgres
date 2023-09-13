module WritePostgres

    using LibPQ
    using Tables
    using DataFrames
    using JSON
    using Dates
    using TimeZones
    using Statistics
    using Distances
    using DotProductGraphs
    using Printf
    using DataFrames
    using LinearAlgebra
    using Languages
    using FameSVD

    include("process_todays_articles.jl")
    include("ReadWritePostgres.jl")
    include("onboard_user.jl")
    include("anomalyDetection.jl")
    include("get_baseline_df.jl") 

    include("WordNetwork/WordNetwork.jl")
    include("WordNetwork/articles_to_word_network.jl")

    include("importedFunctions/kw_data_frame.jl")
    include("importedFunctions/CreateProcessedDf.jl")
    include("importedFunctions/format_text.jl")

    ## Create Processed Columnns
    include("importedFunctions/createProcessedCols/articles_col.jl")
    include("importedFunctions/createProcessedCols/day_text_col.jl")
    include("importedFunctions/createProcessedCols/word_count_col.jl")
    include("importedFunctions/createProcessedCols/sentiment_col.jl")
    include("importedFunctions/createProcessedCols/emb_tok_align_col.jl")
    include("importedFunctions/createProcessedCols/anomalous_day_col.jl")
    include("importedFunctions/createProcessedCols/word_change_col.jl")
    
    # Main Functions 
    export process_todays_articles
    export onboard_user

    # Additional useful functions that are imported by MakeWebJSON
    export user_from_id
    export query_postgres
    export get_back_connection
    export get_forward_connection

end
