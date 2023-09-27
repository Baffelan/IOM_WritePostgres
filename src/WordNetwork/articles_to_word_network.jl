
# using GraphMakie , GLMakie

# PATH = "TestData/"

# fs = readdir(PATH)


# f = JSON.parsefile.(string.(PATH, fs))
"""
This function will return a reference matrix from the given embedding and alignment tokens.
"""
function get_ref_matrix(article::DataFrame, tokens::Base.AbstractVecOrTuple, emb::Int; which_mat::Symbol=:L̂)
    all_text = join(article[!, "body"], " ")

    ftext = format_text(all_text)
    
    wn = WordNetwork(ftext, emb)
    subembedding_from_tokens(wn, tokens, which_mat=which_mat)
end


"""
This function takes in the output of the postgreSQL query in the form of a dataframe and returs a vector of WordNetworks. 
    
These Word networks contain an alignment (Aᵢ) matrix to align the embeddings (Eᵢ), EᵢAᵢ.
"""
function articles_to_word_network(articles::AbstractDataFrame, alignment_tokens::Base.AbstractVecOrTuple, emb::Int, refmatrix::AbstractArray{Float64}, filtered_word_counts::Dict{T, Int})where{T<:AbstractString}
    all_text = join(articles[!, "body"], " ")

    ftext = format_text(all_text)
    
    #println("Processing articles from ", articles[1,"date"]," has been completed")
    wn_s = WordNetwork(ftext, emb, filtered_word_counts)
    # refmatrix = get_ref_matrix(wn_s, alignment_tokens)
    aligning_matrix!(wn_s; tokens=alignment_tokens, A=refmatrix)  
    
    # dist_dicts = word_embedding_dists.([wn_s[1]], wn_s)
    return wn_s
end

# function articles_to_emb_dist(articles::Base.AbstractVecOrTuple{Dict}, alignment_tokens::Base.AbstractVecOrTuple)
#     wn_s = WordNetwork.(articles, [2])
#     refmatrix = get_ref_matrix(wn_s[1], alignment_tokens)
#     aligning_matrix!.(wn_s; tokens=alignment_tokens, A=refmatrix)  
    
#     # dist_dicts = word_embedding_dists.([wn_s[1]], wn_s)
#     return wn_s
# end

