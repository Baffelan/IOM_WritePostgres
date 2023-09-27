articles_col(raw_df::DataFrame, dates::T) where T<:Vector{Union{Missing, Date}} = [unique(raw_df[raw_df.date.==d, :uri]) for d in dates]