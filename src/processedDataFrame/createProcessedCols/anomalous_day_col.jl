"""
Checks if the change in average word distance between `today_df` and `previous_df` is anomalous.
    
# Arguments
- `today_df::DataFrame`: Semi-processed data frame containing information about today's articles.
- `previous_df::DataFrame:` Data frame from `processedarticles` containing yesterdays information.
- `m::Float64`: Mean of the baseline distribution.
- `s::Float64`: Standard deviation of the baseline distribution.
"""
function anomalous_day_col(today_df::DataFrame, previous_df::DataFrame, m::AbstractFloat, s::AbstractFloat)
    anomalies = zeros(Bool, nrow(today_df))
    if nrow(previous_df)>0
        i_mats = create_interacting_embedding(today_df[1,:],previous_df[1,:], transpose_2=true)
        self_dists = word_network_self_dist.(i_mats[1:2])
        day_dist = mean(abs.(self_dists[1].-self_dists[2]))
        if abs(day_dist-m)>2*s
            anomalies[1] = true
        end
    end

    return anomalies

end

"""
Calculates the distance matrix between all rows of the matrix `mat`.

# Arguments
- `mat::Matrix`
- `dist_metric::Function`: Method to calculate the row distances of `mat`.
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