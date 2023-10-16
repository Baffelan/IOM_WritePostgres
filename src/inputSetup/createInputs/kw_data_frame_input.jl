"""
This function takes a keyword and a dataframe and returns the rows that have the keyword in the title.

# Arguments
- `kw::String`: The keyword being searched for.
- `df::DataFrame`: A data frame with a `:body` column containing Strings 
"""
function kw_data_frame_input(kw::String, df::DataFrame)
    has_kw = occursin.([replace(kw, "\""=>"")], format_text.(df.body))
    kw_df = df[has_kw,:]
    kw_df#[1:min(50,nrow(kw_df)),:]
end
