"""
A very rough processing of the text to remove punctuation and extra characters. This reduces the occurences of cases such as "will" and "will," being viewed as different words.

# Arguments
- `text::String`: the text being processed.

# Examples
```jldoctest
julia> format_text("word, word")
"word word"

julia> format_text("word-word")
"word-word"

julia> format_text("word- word")
"word word"
```
"""
function format_text(text::String)
    t = lowercase(text)
    t = string([!in(Base.Unicode.category_code(l),[9,14,15,16,17,19,20] ) ? l : "" for l in t]...) # (1) https://github.com/JuliaStrings/utf8proc/blob/master/utf8proc.h#L280-L311
    t = string([!(Base.Unicode.category_code(l)==9) ? l : "" for l in t]...) # (1)

    
    t = replace(t, ","=>"")
    t = replace(t, "\""=>"")
    t = replace(t, "'"=>"")

    t = replace(t, "\n"=>" ")
    t = replace(t, ":"=>" ")
    t = replace(t, "@"=>"")
    t = replace(t, ";"=>" ")
    t = replace(t, "/"=>" ")
    t = replace(t, "~"=>" ")
    t = replace(t, " -"=>" ")
    t = replace(t, "- "=>" ")


    t = replace(t, "?"=>".")
    t = replace(t, "!"=>".")


    return t
end

