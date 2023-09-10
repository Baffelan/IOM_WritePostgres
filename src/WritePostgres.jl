module WritePostgres

    include("process_todays_articles.jl")
    include("ReadWritePostgres.jl")

    # Main Functions 
    export process_todays_articles
    export onboard_user
    export collect_data

    # Additional useful functions that are imported by MakeWebJSON
    export user_from_id
    export query_postgres
    export get_connection
end
