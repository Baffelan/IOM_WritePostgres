module WritePostgres

    using LibPQ
    using Tables
    using DataFrames
    using JSON


    include("process_todays_articles.jl")
    include("ReadWritePostgres.jl")
    include("onboard_user.jl")

    # Main Functions 
    export process_todays_articles
    export onboard_user
    export collect_data

    # Additional useful functions that are imported by MakeWebJSON
    export user_from_id
    export query_postgres
    export get_back_connection
    export get_forward_connection
end
