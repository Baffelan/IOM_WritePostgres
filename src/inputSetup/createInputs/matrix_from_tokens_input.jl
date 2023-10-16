"""
Extracts a submatrix from embedding where the rows are the token_idx from `tokens`. This is found from the first row of the embedding column of `align_df`.

# Arguments
- `align_df::DataFrame`: A data frame from the `processedarticles` table. 
- `tokens::AbstractVecOrTuple{String}`: A set of words for extracting the submatrix.
"""
matrix_from_tokens_input(align_df, tokens) = hcat(sub_index(align_df[1,:embedding]', sub_index(JSON.parse(align_df[1,:token_idx]), tokens))...)