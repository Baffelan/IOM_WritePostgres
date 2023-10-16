"""
Calculates and returns the inputs for `create_processed_df`.
    !Keyword dependent!
    kw_dataframes: the array of dataframes that are associated with each keyword.
    kws: the array of keywords.
    base_dist: the found distribution of word distances for each keword.

    !Keyword independent!
    [refmatrix]: the matrix that each embedding is aligned to.

# Arguments
- `df::DataFrame`: Data frame from `raw` table.
- `burnin::Tuple{Date, Date}`: A date range for which the baseline distribution is found.
- `user_agg::String`: The keyword identifying an aggregate of all articles ("[userID]_aggregated").
- `alignment_tokens::AbstractVecOrTuple{String}`: A set of words for extracting the submatrix used for aligning embeddings.
- `calc_distribution::Bool`: Used to set whether a baseline distribution should be calculated. For daily analysis this should be `true`; for onboarding it should be `false`.
"""
function set_up_inputs(df, burnin, user_agg, alignment_tokens, calc_distribution::Bool)
    kws = rsplit(df.keywords[1][2:end-1],",")
    kw_dataframes = [kw_data_frame_input.(kws, [df]); df]

    kws = vcat(kws..., user_agg)
    base_dist, refmatrix = (0.0, 1.0), Matrix(undef, 0,0)
    if calc_distribution
        base_dist, align_df = base_dist_input(999, burnin, kws, user_agg)
        refmatrix = matrix_from_tokens_input(align_df, alignment_tokens)
    end

    
    return kw_dataframes, kws, base_dist, refmatrix
end