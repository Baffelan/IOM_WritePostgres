
function day_text_col(raw_df::DataFrame, dates::T)where T<:Vector{Union{Missing, Date}}
    
    day_text = [join(raw_df[raw_df.date.==d, :body], " ") for d in dates]
    ftext = format_text.(day_text)
end