
"""
Takes a series of arguments:
    raw_df{DataFrame}: a data frame from raw table (in practice this will be a filtered data frame with all articles from a given keyword).
    kw{AbstractString}: the keyword that is being analysed.
    alignment_tokens{Base.AbstractVecOrTuple}: a tuple of common words for trying to align the embeddings of each word network.
    refmatrix{Union{Nothing, AbstractArray}}: an m✖n matrix that each embedding is being aligned to, the rows correspond to the words in alignment_tokens.
    emb_dim{Int}: The dimension of the embedding of the work networks (if refmatrix is not nothing, emb_dim must equal n).
    base_dist{Float64}: The baseline mean for this keyword and the baseline standard deviation for this keyword

    Returns a DataFrame to be appended to the processed table
"""
function create_processed_df(raw_df::DataFrame, 
                             kw::AbstractString, 
                             alignment_tokens::Base.AbstractVecOrTuple, 
                             refmatrix::Union{Nothing, AbstractArray}, 
                             emb_dim::Int, 
                             base_dist::Base.AbstractVecOrTuple{AbstractFloat},
                             days::Base.AbstractVecOrTuple{Date})
    println("Analysing keyword: ",kw)
    println(string("DataFrame has ", nrow(raw_df)," rows."))
    println("")
    base_mean, base_std = base_dist
    df = DataFrame("date"=>sort(unique(raw_df.date)))
    df[!, :keyword] .= kw
    df[!, :articles] = articles_col(raw_df, df.date)
    df[!, :day_text] = day_text_col(raw_df, df.date)
    df[!, :word_count] = word_count_col.(df[!,:day_text])
    df[!, :sentiment] = sentiment_col(raw_df, df.date)

    embedding, token_idx, aligning_matrix = emb_tok_align_col(raw_df, df.date, alignment_tokens, refmatrix, emb_dim, df.word_count)

    df[!, :embedding] = embedding
    df[!, :token_idx] = token_idx
    df[!, :aligning_matrix] = aligning_matrix

    df[!, :anomalous_day] = anomalous_day_col(df, base_mean, base_std)
    df[!, :word_change] = nrow(raw_df)==0 ? [] : word_change_col(df)

    # net_df[!,:most_shared] = most_shared.(dfs_trace)
    df
end
