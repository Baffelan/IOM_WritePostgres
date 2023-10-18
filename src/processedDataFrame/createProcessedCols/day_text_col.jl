"""
Concatenates the body text from `raw_df` for each day in `dates` and processes it according to `format_text` function.

# Arguments
- `raw_df::DataFrame`: Data frame from the `raw` table.
- `dates::T where T<:Vector{Union{Missing, Date}}`: Dates for which we want the processed text.
"""
function day_text_col(raw_df::DataFrame, dates::T)where T<:Vector{Union{Missing, Date}}
    
    day_text = [join(raw_df[raw_df.date.==d, :body], " ") for d in dates]
    ftext = format_text.(day_text)
end