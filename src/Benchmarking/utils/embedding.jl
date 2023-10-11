""" 
A wrapper for getting an SVD embedding of a graph using the `fast_svd` function as the method.
    
# Arguments
- `graph::AbstractMatrix{AbstractFloat}`: the graph which is being decomposed.
- `emb_dim::Int`: the dimension of the embedding.
"""
function embedding(graph, emb_dim)
    DotProductGraphs.svd_embedding(graph, fast_svd, emb_dim)[:L̂]
end