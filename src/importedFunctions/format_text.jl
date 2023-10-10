"""
A very rough processing of the text to reduce the occurences of cases such as "will" and "will," being viewed as different words.

More sophisticated processing is readily possible. A potential example of how in (1), where the Unicode category_code can be used to remove particular types of characters.

returns formated text.
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

