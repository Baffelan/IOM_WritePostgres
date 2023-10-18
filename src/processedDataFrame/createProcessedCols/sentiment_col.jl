"""
Calculates the average sentiment of `raw_df` for each day in `dates`.

# Arguments
- `raw_df::DataFrame`: Data frame from the `raw` table.
- `dates::T where T<:Vector{Union{Missing, Date}}`: Dates for which we want the average sentiment.
"""
sentiment_col(raw_df::DataFrame, dates::T) where T<:Vector{Union{Missing, Date}} = [mean(skipmissing(raw_df[raw_df.date.==d, :sentiment])) for d in dates]