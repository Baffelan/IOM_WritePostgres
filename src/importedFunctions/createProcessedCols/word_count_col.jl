
"""
Produces a dictionary of words->number of occurances in a given text.
Used for making the word cloud.
"""
function word_count_col(text::AbstractString)
    sw = stopwords(Languages.English())

    not_sw = [in(_t,sw) ? nothing : _t for _t in rsplit(replace(text, "."=>""), " ")]

    not_sw = not_sw[not_sw.!=nothing]
    not_sw = not_sw[length.(not_sw).>1]

    tally = combine(groupby(DataFrame(:words=>not_sw), :words),nrow)
    word_count = Dict(zip(tally[!,:words], tally[!,:nrow]))
    Dict([k=>v for (k,v) in pairs(word_count) if v>5])
end