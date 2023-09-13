# """
# The aim of this file is to return a json file with information about outliers that have been identified from the collected data

# Rough Steps:
#     postgreSQLquery to get data from server

#     textGraph (should rename) to transform data to embedding

#     Detect anomalies

#     build json

# File needs distance dictionaries, dataframe from postgreSQL
# """

using Dates



"""
Aligns the indeces of each 
"""
function create_interacting_embedding(df1::DataFrameRow, df2::DataFrameRow)
    toks1 = df1.token_idx
    toks2 = df2.token_idx

    all_toks = union(keys(toks1), keys(toks2))
    int_toks = intersect(keys(toks1), keys(toks2))
    
    emb_dim = max(size(df1.embedding)[2], size(df2.embedding)[2])

    bigm1 = zeros(Float64, (length(all_toks), emb_dim))
    bigm2 = zeros(Float64, (length(all_toks), emb_dim))

    int_locs1 = [toks1[k] for k in int_toks]
    int_locs2 = [toks2[k] for k in int_toks]


    bigm1[1:length(int_toks),:].=df1.embedding[int_locs1,:]

    non_int1 = [toks1[k] for k in setdiff(keys(toks1),int_toks)]
    bigm1[length(int_toks)+1:length(int_toks)+length(non_int1),:].=df1.embedding[non_int1,:]

    
    bigm2[1:length(int_toks),:].=df2.embedding[int_locs2,:]

    non_int2 = [toks2[k] for k in setdiff(keys(toks2), int_toks)]
    bigm2[length(int_toks)+1+length(non_int1):end,:].=df2.embedding[non_int2,:]
    return bigm1, bigm2, vcat([k for k in int_toks], [k for k in setdiff(keys(toks1),int_toks)], [k for k in setdiff(keys(toks2), int_toks)])

end



"""
Takes 2 embeddings and calculates the pairwise distances between the rows
"""
word_network_self_dist(mat::Matrix; dist_metric=Euclidean()) = pairwise(dist_metric, mat, dims=1)



function get_baseline_dists_day(base_df::DataFrame)
    # burnin_dict = NamedTuple{String, AbstractArray}(x̄=>0.0, σ=>0.0)
    distances = Vector{Float64}()
    for r in 2:nrow(base_df)
        i_mats = create_interacting_embedding(base_df[r],base_df[r-1])
        self_dists = word_network_self_dist.(i_mats[1:2])
        dists = mean(abs.(self_dists[1].-self_dists[2]))
        push!(distances, dists)
    end
    return mean(distances), std(distances)

end


"""
    Finds the anomalous words in a list of WordNetworks.
    Looks for difference in variance of distances,
        and difference in means (either same variance or different variance, according to the results of the previous test)
    
    To do this a burn in period is used to find a baseline distribution of word distances

    Inputs:
        WordNetworks (Array{WordNetwork})
        burn in period (Range{Int})
    
    Output:
        undetermined
"""




