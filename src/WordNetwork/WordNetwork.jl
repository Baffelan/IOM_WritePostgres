using Graphs
using MetaGraphs
using DotProductGraphs
using Printf
using DataFrames
using LinearAlgebra
"""
WordNetwork is a struct for handling operations for which we need a mixture of information.

This includes:
    TextGraph structure (text_graph)
    SVD embedding (embedding)
    Dictionary from word to index in the text_graph and embedding (token_idx)
    
    Alignment transformation (aligning_graph)

"""
mutable struct WordNetwork
    # raw::Dict{String, Any}
    text_graph::AbstractArray{Bool}
    embedding::NamedTuple{(:L̂, :R̂), Tuple{Matrix{Float64}, Matrix{Float64}}}
    token_idx::Dict{String, Int}

    # Optional
    aligning_matrix::Union{Matrix{Float64}, Nothing}
end

Base.show(io::IO, ::MIME"text/plain", f::WordNetwork) = @printf(io, "WordNetwork with %s unique tokens",length(keys(f.token_idx)))


# function WordNetwork(raw::Dict, emb_d::Int)
# """
#   this function is a holdover from when Connor was making networks for individual articles. 
#   For these articles, the edges are generated by sequential words not coocurrence in sentence.
# """
#     text_graph = lemma_graph.(raw["body"])
#     embedding = DotProductGraphs.svd_embedding(Matrix(adjacency_matrix(text_graph)), emb_d)

#     tokens = get_prop.([text_graph], 1:nv(text_graph),:token)
#     flip_enumerate(l) = map(x-> (l[x], x), eachindex(l))
#     etokens = flip_enumerate(tokens)
#     token_idx = Dict(etokens)

#     alignment_matrix = nothing    

#     WordNetwork(raw, text_graph, embedding, token_idx, alignment_matrix)
# end
"""
    Generates and returns both the coocurrence matrix for a piece of formatted text (ideally all lowercase, no numbers, and the only punctuation is a fullstop) 
    unit is the character upon which to split the string for defining nodes.
    coocur is the character to split the string to define a relation.
"""
function coocurrence_matrix(text::String; unit::AbstractChar=' ', coocur::AbstractChar='.')
    words = rsplit(replace(text, coocur=>" "), unit)
    unique!(words)

    token_idx = Dict(zip(words, 1:length(words)))

    mat = zeros(Bool, (length(words), length(words)))

    
    sentences = rsplit(text, coocur)
    for sent in sentences
        
        for word1 in unique(rsplit(sent, unit)) 
            for word2 in unique(rsplit(sent, unit))
                if (word1 != "" && word2!="") 
                    @inbounds mat[token_idx[word1],token_idx[word2]]=1
                end
            end
        end
    end
    return mat, token_idx
end

function qr_svd(Mat::T, dim::O = nothing) where {T <: AbstractMatrix, O <: Union{Nothing,<:Int,Function}}

    L,Σ,Rt = svd(Mat, alg=LinearAlgebra.QRIteration())

    d = isnothing(dim) ? d_elbow(Σ) :
        isinteger(dim) ? dim :
        dim(Mat)

    L = L[:,1:d]
    Σ = Σ[1:d]
    Rt = Rt[:,1:d]
    return L, Σ, Rt
  
end

function WordNetwork(text::String, emb_d::Int)
    text_graph, token_idx = coocurrence_matrix(text)
    println(length(text))
    embedding=NamedTuple()
    try
        embedding = DotProductGraphs.svd_embedding(text_graph, min(size(text_graph)[1],emb_d))
    catch e
        embedding = DotProductGraphs.svd_embedding(text_graph, qr_svd, min(size(text_graph)[1],emb_d))
    end;
    
    alignment_matrix = nothing    

    WordNetwork(text_graph, embedding, token_idx, alignment_matrix)
end


"""
    Calculates the direction vectors from WN1, to WN2.
    This is done for every word that the two WordNetworks have in common.
    This will be done for matrices that have been alligned, if an aligning matrix exists.
"""
function word_embedding_dists(dt1::Dict{String, Int}, E1::Matrix{Float64}, dt2::Dict{String, Int}, E2::Matrix{Float64})
    ints = intersect(keys(dt1), keys(dt2))
    dists=[]
    for int in ints
        i1=dt1[int]
        i2=dt2[int]
        push!(dists, E2[i2,:].-E1[i1,:])
    end
    return Dict(zip(ints, dists))
end

function word_embedding_dists(wn1::WordNetwork, wn2::WordNetwork)
    if (isnothing(wn1.aligning_matrix) || isnothing(wn2.aligning_matrix))
        return word_embedding_dists(wn1.token_idx, wn1.embedding[:L̂], wn2.token_idx, wn2.embedding[:L̂])
    else
        E1 = wn1.embedding[:L̂]*wn1.aligning_matrix
        E2 = wn2.embedding[:L̂]*wn2.aligning_matrix
        return word_embedding_dists(wn1.token_idx, E1, wn2.token_idx, E2)
    end
    
end


sub_index(l::Dict, is) = map(x->l[x], is)
sub_index(l::AbstractArray, is) = map(x->l[x,:], is)
sub_index(l::AbstractArray, is) = map(x->l[x,:], is)

"""
    A function that returns the submatrix associated with the tokens in the ALIGNMENT Tuple
    this matrix is used to align the larger embedding matrix.
"""
function subembedding_from_tokens(wn::WordNetwork, tokens::Base.AbstractVecOrTuple; which_mat::Symbol=:L̂, aligned::Bool=false)
    alignment_locs = sub_index(wn.token_idx, tokens)
    if (aligned && !(isnothing(wn.aligning_matrix)))
        return hcat(sub_index(wn.embedding[:L̂]*wn.aligning_matrix, alignment_locs)...)'
    else
        return hcat(sub_index(wn.embedding[:L̂], alignment_locs)...)'
    end
    
end


function soft_subembedding_from_tokens(wn::WordNetwork; tokens::Base.AbstractVecOrTuple=ALIGNMENT, which_mat::Symbol=:L̂, aligned::Bool=false)

    token_intersect = tokens[[in(t, keys(wn.token_idx)) for t in tokens]]
    subembedding_from_tokens(wn, token_intersect; aligned=true)
end


"""
    Sets the aligning_matrix of wn to one which will transformation the matrix returned by "subembedding_from_tokens" to A.
    (or as close as possible)
"""

function aligning_matrix!(wn::WordNetwork; A::AbstractArray=REFMATRIX, tokens::Base.AbstractVecOrTuple=ALIGNMENT)
    subemb = soft_subembedding_from_tokens(wn, tokens=tokens)
    kept_tokens = [in(t, keys(wn.token_idx)) for t in tokens]
    if sum(kept_tokens)<(1+size(A)[2])
        wn.aligning_matrix=nothing
    else
        sub_A = A[kept_tokens,:]
        wn.aligning_matrix = subemb\sub_A

    end
end

Base.getindex(wn::WordNetwork, idxs::AbstractVecOrMat{String}) = subembedding_from_tokens(wn; tokens=idxs)
Base.getindex(wn::WordNetwork, idxs::String) = Base.getindex(wn, [idxs])