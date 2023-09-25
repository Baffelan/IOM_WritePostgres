"""
Returns the required inputs for create_processed_df.
    !Keyword dependent!
    kw_dataframes: the array of dataframes that are associated with each keyword.
    kws: the array of keywords.
    base_dist: the found distribution of word distances for each keword.

    !Keyword independent!
    [refmatrix]: the matrix that each embedding is aligned to.
"""
function set_up_inputs(df, burnin, user_agg, ALIGNMENT_TOKENS, calc_distribution::Bool)
    # !Keyword dependent!
    kws = rsplit(df.keywords[1][2:end-1],",")
    kw_dataframes = kw_data_frame_input.(kws, [df])
    base_dist, refmatrix = (0.0, 1.0), Matrix(undef, 0,0)
    if calc_distribution
        base_dist, align_df = base_dist_input(999, burnin, kws, user_agg)
        refmatrix = refmatrix_input(align_df, ALIGNMENT_TOKENS)
    end

    # !Keyword independent!
    
    return kw_dataframes, kws, base_dist, refmatrix
end