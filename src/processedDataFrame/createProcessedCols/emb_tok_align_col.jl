function emb_tok_align_col(raw_df::DataFrame, 
                           dates::Vector{Union{Missing, Date}}, 
                           alignment_tokens::Base.AbstractVecOrTuple,
                           refmatrix::Union{Nothing, AbstractArray},
                           emb_dim::Int,
                           filtered_word_counts::Vector{Dict{T, Int}}) where{T<:AbstractString}
    word_nets = articles_to_word_network.([raw_df[raw_df.date.==d,:][min(100, sum(raw_df.date.==d)),:] for d in dates], [alignment_tokens], emb_dim, [refmatrix], filtered_word_counts);

    embedding = [wn.embedding[:L̂] for wn in word_nets]
    token_idx = [wn.token_idx for wn in word_nets]
    aligning_matrix = [wn.aligning_matrix for wn in word_nets]

    return embedding, token_idx, aligning_matrix
end
