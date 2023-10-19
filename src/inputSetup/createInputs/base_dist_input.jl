"""
gets a baseline distribution of movements (mean, std) of word movement from one day to the next.

# Arguments
- `userID::Int`: The ID of the user being processed.
- `burnin::Tuple{Date, Date}`: A date range for which the baseline distribution is found.
- `kws::Tuple{String}`: The keywords for which a baseline will be found.
- `user_agg::String`: The keyword identifying an aggregate of all articles ("[userID]_aggregated").
"""
function base_dist_input(userID::Int, burnin::Vector, kws::Tuple{AbstractString}, user_agg)
    baseline_df = get_baseline_df(userID, (burnin[1],burnin[2]))
    base_dict = Dict([df.keyword[1]=>df for df in baseline_df]...)
    base_dist = [get_baseline_dist(base_dict[k]) for k in kws if k in keys(base_dict)]
    align_df = base_dict[user_agg]
    return base_dist, align_df
end

"""
Collects processed articles to be used for establishing a baseline distribution. These articles are then broken down by keyword and returned as a vector of DataFrames.

# Arguments
- `userID::Int`: The ID of the user being processed.
- `burnin::Tuple{Date, Date}`: A date range for which the baseline distribution is found.
"""
function get_baseline_df(userID::Int, burnin::Tuple{Date, Date})
    df = query_postgres("processedarticles", "back", condition = string("WHERE user_ID='",userID,"'",
                                                                        "AND date<='",burnin[2],"' ",
                                                                        "AND DATE >= '",burnin[1],"'"))

    if nrow(df)==0
        println("A baseline has not been processed for this user.")
        println("Please onboard them with the function: [onboard_user]")        
    end

    all_kws = unique(df.keyword)
    println(all_kws)
    kw_dfs = [df[df.keyword.==w,:] for w in all_kws]
end

"""
Calculates a baseline distribution for a given DataFrame from `processedarticles` table.

# Arguments
- `base_df::DataFrame`: A data frame from the 'processedarticles` table with at least 2 rows.
"""
function get_baseline_dist(base_df::DataFrame)
    # burnin_dict = NamedTuple{String, AbstractArray}(x̄=>0.0, σ=>0.0)
    println(unique(base_df.keyword))
    distances = Vector{Float32}()
    for r in 2:nrow(base_df)
        row = DataFrame(:embedding=>[base_df[r,:embedding]', base_df[r-1,:embedding]'], :token_idx=>[JSON.parse(base_df[r,:token_idx]), JSON.parse(base_df[r-1,:token_idx])])
        i_mats = create_interacting_embedding(row[1,:],row[2,:])
        self_dists = word_network_self_dist.(i_mats[1:2])
        dists = mean(abs.(self_dists[1].-self_dists[2]))
        push!(distances, dists)
    end
    return mean(distances), std(distances)

end
