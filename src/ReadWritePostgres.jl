"""
Function to query the postgres server. 

table is the table in the server that is being queried from.

condition is an optional argument that is joined at the end of the query and will take the form of the second half of a SQL query:
    eg "WHERE lang='eng'"

test is a bool where if true, the query string is returned rather than executing the query.

sorted determines if the resulting dataframe should be sorted by date. When accessing the api.Readers table this must be set to false.
"""
function query_postgres(table::String, which_db::String; condition::String="", test::Bool=false, sorted::Bool=true)
    q = "SELECT * FROM $(table) $(condition)"

    c = ""
    if which_db=="forward"
        c = get_forward_connection()
    elseif which_db=="back"
        c = get_back_connection()
    end

    if test
        return q
    else
        conn = LibPQ.Connection(c)
        result = execute(conn, q)
        if sorted
            arts = sort(DataFrame(result),:date)
        else
            arts=DataFrame(result)
        end
        close(conn);
        return arts
    end
end


"""
helper function for parsing julia array to postgres format
"""
parse_array(A::AbstractArray) = replace(replace(JSON.json(A),"["=>"{"),"]"=>"}")
parse_array(A::Nothing) = "{}"


"""
Loads data into the table with the schema from ProcessedArticles in the IOM_MakePostgresTables
"""
function load_processed_data(net_df)
    println(net_df.aligning_matrix)
    conn = LibPQ.Connection(get_back_connection())
    execute(conn, "BEGIN;")
    
    LibPQ.load!(
        (
            date=net_df.date, 
            keyword=net_df.keyword,
            user_ID=net_df.user_ID,
            day_text=net_df.day_text, 
            word_cloud=JSON.json.(net_df.word_count),
            sentiment=net_df.sentiment,
            word_changes=JSON.json.(net_df.word_change),
            articles=parse_array.(net_df.articles),
            embedding=parse_array.(net_df.embedding),
            token_idx=JSON.json.(net_df.token_idx),
            aligning_matrix=parse_array.(net_df.aligning_matrix),
            anomalous_day=net_df.anomalous_day
        ),
        conn,
        "INSERT INTO ProcessedArticles (date, keyword, user_ID, day_text, word_cloud, sentiment, word_changes, articles, embedding, token_idx, aligning_matrix, anomalous_day) VALUES (\$1, \$2, \$3, \$4, \$5, \$6, \$7, \$8, \$9, \$10, \$11, \$12);"
    );

    execute(conn, "COMMIT;")
end


"""
T

"""
function add_new_user(user_dict)
    conn = LibPQ.Connection(get_forward_connection())
    execute(conn, "BEGIN;")
    
    LibPQ.load!(
        (
            userID=[user_dict["userID"]],
            collectionID=[user_dict["collectionID"]],
            information=[user_dict["information"]], 
            keywords=[user_dict["keywords"]],
        ),
        conn,
        "INSERT INTO api.readers (userID, collectionID, information, keywords) VALUES (\$1, \$2, \$3, \$4);"
    );

    execute(conn, "COMMIT;")
end




"""
creates a LibPQ connection String
"""
function get_back_connection()
    if haskey(ENV, "IOMBCKUSER") * haskey(ENV, "IOMBCKPASSWORD") * haskey(ENV, "IOMBCKHOST") * haskey(ENV, "IOMBCKPORT") * haskey(ENV, "IOMBCKDB")
        conn = "postgres://$(ENV["IOMBCKUSER"]):$(ENV["IOMBCKPASSWORD"])@$(ENV["IOMBCKHOST"]):$(ENV["IOMBCKPORT"])/$(ENV["IOMBCKDB"])"
        return conn
    else
        error("Missing Keys in the Environment variables")
    end
end
"""
creates a LibPQ connection String
"""
function get_forward_connection()
    if haskey(ENV, "IOMFRNTUSER") * haskey(ENV, "IOMFRNTPASSWORD") * haskey(ENV, "IOMFRNTHOST") * haskey(ENV, "IOMFRNTPORT") * haskey(ENV, "IOMFRNTDB")
        conn = "postgres://$(ENV["IOMFRNTUSER"]):$(ENV["IOMFRNTPASSWORD"])@$(ENV["IOMFRNTHOST"]):$(ENV["IOMFRNTPORT"])/$(ENV["IOMFRNTDB"])"
        return conn
    else
        error("Missing Keys in the Environment variables")
    end
end

"""
Takes a dictionary with information about a user and adds them to the api.Readers table.

Example:
user_info = JSON.json(Dict("name"=>"John Smith", "details"=>"useful customer info"))
user_keywords = JSON.json(Dict("keywords"=>["facebook", "twitter", "meta", "metaverse"], 
                               "location"=>"USA", 
                               "language"=>"eng"))
user = Dict("userID"=>999, "collectionID"=>1, "information"=>user_info, "keywords"=>user_keywords)

add_new_user(user)
"""
function user_from_id(userID)

    user_df = query_postgres("api.readers", "forward", condition=string("WHERE userID='",userID,"'"), sorted=false)
    
    user = Dict{Symbol, Any}(pairs(user_df[1,:]))
    user[:keywords] = JSON.parse(user[:keywords])
    user[:information] = JSON.parse(user[:information])

    return user
end 



