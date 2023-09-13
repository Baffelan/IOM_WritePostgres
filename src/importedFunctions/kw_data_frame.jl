
"""
This function takes a keyword and a dataframe and returns the rows that have the keyword in the title.

(In the title because that is where the current api query searches for them, when that changes this should too)
"""
function kw_data_frame(kw, df)
    df[occursin.([kw], format_text.(df.body)),:]    
end
