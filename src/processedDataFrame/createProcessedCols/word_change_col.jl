"""
Calculates how much each word has moved between 1 day and the next.

TODO:
Integrate this function into anomalous_day_col, as much of the functionality is similar. anomalous_day_col has been updated to be more readable and efficient and so should be used as the foundation of the new code.
"""
function word_change_col(df)
    change_dicts = [Dict()]
    for r in 2:nrow(df)
        i_mats = create_interacting_embedding(df[r,:],df[r-1,:])
        self_dists = word_network_self_dist.(i_mats[1:2])
        word_dists = [mean(abs.(r)) for r in eachrow(self_dists[1].-self_dists[2])]
        d = Dict()
        for (k,v) in pairs(i_mats[3])
            d[v] = word_dists[k]
        end
        push!(change_dicts, d)
    end
    return change_dicts

end

# function find_mean_word_dist(wn_s::AbstractArray)
#     #m, s = get_burnin_dists_day(wn_s, burnin)
    
    
#     check_range = 2:length(wn_s)
#     change_dicts = []
#     for i in check_range[1:end]
#         i_mats = create_interacting_embedding(wn_s[i],wn_s[i-1])
#         self_dists = word_network_self_dist.(i_mats[1:2])
#         word_dists = [mean(abs.(r)) for r in eachrow(self_dists[1].-self_dists[2])]
#         d = Dict()
#         for (k,v) in pairs(i_mats[3])
#             d[v] = word_dists[k]
#         end
#         push!(change_dicts, d)
#     end
#     return change_dicts

# end