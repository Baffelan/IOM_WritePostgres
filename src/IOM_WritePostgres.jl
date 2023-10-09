module IOM_WritePostgres

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
    using LoopVectorization


    include("process_todays_articles.jl")
    include("ReadWritePostgres.jl")
    include("process_articles.jl")

    include("WordNetwork/WordNetwork.jl")
    include("WordNetwork/articles_to_word_network.jl")
    include("WordNetwork/fast_svd.jl")
    

    #include("importedFunctions/kw_data_frame.jl")
    include("importedFunctions/format_text.jl")
    include("importedFunctions/create_interacting_embodding.jl")


    ## Create Processed Columnns
    include("processedDataFrame/CreateProcessedDf.jl")

    include("processedDataFrame/createProcessedCols/articles_col.jl")
    include("processedDataFrame/createProcessedCols/day_text_col.jl")
    include("processedDataFrame/createProcessedCols/word_count_col.jl")
    include("processedDataFrame/createProcessedCols/sentiment_col.jl")
    include("processedDataFrame/createProcessedCols/emb_tok_align_col.jl")
    include("processedDataFrame/createProcessedCols/anomalous_day_col.jl")
    include("processedDataFrame/createProcessedCols/word_change_col.jl")

    ## Get inputs for processed df
    include("inputSetup/createInputs/base_dist_input.jl")
    include("inputSetup/createInputs/kw_data_frame_input.jl")
    include("inputSetup/createInputs/refmatrix_input.jl")
    include("inputSetup/set_up_inputs.jl")
    
    # Main Functions 
    export process_todays_articles
    export onboard_user

    # Additional useful functions that are imported by MakeWebJSON
    export user_from_id
    export query_postgres
    export get_back_connection
    export get_forward_connection

end
