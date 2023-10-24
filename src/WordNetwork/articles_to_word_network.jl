# """
# This function will return a reference matrix from the given embedding and alignment tokens.
# """
# function get_ref_matrix(article::DataFrame, tokens::Base.AbstractVecOrTuple, emb::Int; which_mat::Symbol=:L̂)
#     all_text = join(article[!, "body"], " ")

#     ftext = format_text(all_text)
    
#     wn = WordNetwork(ftext, emb)
#     subembedding_from_tokens(wn, tokens, which_mat=which_mat)
# end


"""
Takes in a data frame from 'raw' table, and returns  a 'WordNetwork' from the combined (and processed) text of the data frame. 
This 'WordNetwork' contain an alignment (Aᵢ) matrix to align the embeddings (Eᵢ), EᵢAᵢ.

# Arguments
- 'articles::AbstractDataFrame': A data frame from the 'raw' table.
- 'alignment_tokens::Base.AbstractVecOrTuple': A vector of tokens that will be used to align the graph embedding matrix.
- 'emb_dim::Int': The dimension required for the embedding.
- 'refmatrix::AbstractArray{Float64}': The reference matrix which the embedding will be aligned to.
- 'filtered_word_counts::Dict{T, Int} where {T<:AbstractString}': A dictionary from token=>token_idx wich contains tokens that will be used in the network (tokens that have been used frequently enough).
"""
function articles_to_word_network(articles::AbstractDataFrame, alignment_tokens::Base.AbstractVecOrTuple, emb_dim::Int, refmatrix::AbstractArray{Float64}, filtered_word_counts::Dict{T, Int})where{T<:AbstractString}
    all_text = join(articles[!, "body"], " ")
    ftext = format_text(all_text)

    wn = WordNetwork(ftext, emb_dim, filtered_word_counts)
    aligning_matrix!(wn; tokens=alignment_tokens, A=refmatrix)  
    
    return wn
end



