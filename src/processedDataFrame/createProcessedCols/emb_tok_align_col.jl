"""
Finds the embedding, token to index dictionary, and aligning matrix for each date in `dates` from the `raw_df`.

# Arguments
- `raw_df::DataFrame`: a data frame from raw table (in practice this will be a filtered data frame with all articles from a given keyword).
- `Dates::Vector{Union{Missing, Date}}`: The dates for which we want the embedding, token to index dictionary, and aligning matrix.
- `alignment_tokens::Base.AbstractVecOrTuple`: a tuple of common words for trying to align the embeddings of each word network.
- `refmatrix::Union{Nothing, AbstractArray}`: an m✖n matrix that each embedding is being aligned to, the rows correspond to the words in alignment_tokens.
- `emb_dim::Int`: The dimension of the embedding of the work networks (if refmatrix is not nothing, emb_dim must equal n).
- `filtered_word_counts::Vector{Dict{T, Int}} where{T<:AbstractString}`: A list of dictionaries that indicate which words are occur frequently enough to be used in the word network.    
"""
function emb_tok_align_col(raw_df::DataFrame, 
                           dates::Vector{Union{Missing, Date}}, 
                           alignment_tokens::Base.AbstractVecOrTuple,
                           refmatrix::Union{Nothing, AbstractArray},
                           emb_dim::Int,
                           filtered_word_counts::Vector{Dict{T, Int}}) where{T<:AbstractString}
    word_nets = articles_to_word_network.([raw_df[raw_df.date.==d,:][1:min(100, sum(raw_df.date.==d)),:] for d in dates], [alignment_tokens], emb_dim, [refmatrix], filtered_word_counts);

    embedding = [wn.embedding[:L̂] for wn in word_nets]
    token_idx = [wn.token_idx for wn in word_nets]
    aligning_matrix = [wn.aligning_matrix for wn in word_nets]

    return embedding, token_idx, aligning_matrix
end
