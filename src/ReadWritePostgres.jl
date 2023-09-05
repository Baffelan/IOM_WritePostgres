using LibPQ, Tables, DataFrames, JSON

"""
Function to query the postgres server. 

table is the table in the server that is being queried from.

condition is an optional argument that is joined at the end of the query and will take the form of the second half of a SQL query:
    eg "WHERE lang='eng'"

test is a bool where if true, the query string is returned rather than executing the query.
"""
function query_postgres(table::String; condition::String="", test::Bool=false, sorted::Bool=true)
    q = "SELECT * FROM $(table) $(condition)"
    if test
        return q
    else
        conn = LibPQ.Connection(get_connection())
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
parse_array(A::Nothing) = []


"""
Loads data into the table with the schema from createNewsAPITable.py
"""
function load_processed_data(net_df)
    conn = LibPQ.Connection(get_connection())
    execute(conn, "BEGIN;")
    
    LibPQ.load!(
        (
            date=net_df.date, 
            keyword=net_df.keyword,
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
        "INSERT INTO ProcessedArticles (date, keyword, day_text, word_cloud, sentiment, word_changes, articles, embedding, token_idx, aligning_matrix, anomalous_day) VALUES (\$1, \$2, \$3, \$4, \$5, \$6, \$7, \$8, \$9, \$10, \$11);"
    );

    execute(conn, "COMMIT;")
end



function add_new_user(user_dict)
    conn = LibPQ.Connection(get_connection())
    execute(conn, "BEGIN;")
    
    LibPQ.load!(
        (
            ID=[user_dict["ID"]], 
            name=[user_dict["name"]],
            information=[user_dict["information"]], 
            keywords=[parse_array(user_dict["keywords"])],
            location=[user_dict["location"]]
        ),
        conn,
        "INSERT INTO Users (ID, name, information, keywords, location) VALUES (\$1, \$2, \$3, \$4, \$5);"
    );

    execute(conn, "COMMIT;")
end




"""
creates a LibPQ connection String
"""
function get_connection(;path="connection.json")
    conn_d = JSON.parsefile(path)
    conn = string([string(p, "=", k, " ") for (p,k) in pairs(conn_d)]...)
end

