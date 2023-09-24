"""
This function takes a keyword and a dataframe and returns the rows that have the keyword in the title.

(In the title because that is where the current api query searches for them, when that changes this should too)
"""
function kw_data_frame_input(kw, df)
    has_kw = occursin.([replace(kw, "\""=>"")], format_text.(df.body))
    kw_df = df[has_kw,:]
    kw_df#[1:min(50,nrow(kw_df)),:]
end
