"""
Extracts a unique list of article uri's from `raw_df` for the given `dates`.

# Arguments
- `raw_df::DataFrame`: Data frame from the `raw` table.
- `dates::T where T<:Vector{Union{Missing, Date}}`: Dates for which we want the list of uri's.
"""
articles_col(raw_df::DataFrame, dates::T) where T<:Vector{Union{Missing, Date}} = [unique(raw_df[raw_df.date.==d, :uri]) for d in dates]