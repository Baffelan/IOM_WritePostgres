function anomalous_day_col(df, m, s)
    anomalies = zeros(Bool, nrow(df))
    for r in 2:nrow(df)
        i_mats = create_interacting_embedding(df[r,:],df[r-1,:])
        self_dists = word_network_self_dist.(i_mats[1:2])
        day_dist = mean(abs.(self_dists[1].-self_dists[2]))
        if abs(day_dist-m)>2*s
            anomalies[r] = true
        end
    end
    return anomalies

end

"""
Takes 2 embeddings and calculates the pairwise distances between the rows
"""
word_network_self_dist(mat::Matrix; dist_metric=Euclidean()) = pairwise(dist_metric, mat, dims=1)



# function find_anomalies_day(wn_s::AbstractArray, burnin::AbstractRange)
#     m, s = get_burnin_dists_day(wn_s, burnin)
    
#     check_range = burnin[end]+1:length(wn_s)
#     anomalies = []
#     for i in check_range[1:end]
#         i_mats = create_interacting_embedding(wn_s[i],wn_s[i-1])
#         self_dists = word_network_self_dist.(i_mats[1:2])
#         day_dist = mean(abs.(self_dists[1].-self_dists[2]))
#         if abs(day_dist-m)>2*s
#             push!(anomalies, i)
#         end
#     end
#     return anomalies

# end