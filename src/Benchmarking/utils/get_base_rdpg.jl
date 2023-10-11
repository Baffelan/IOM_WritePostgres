set_max(n, m) = n>m ? m : n
set_min(n, m) = n<m ? m : n

"""
Takes a date and keyword, then retrieves an embedding from `processedarticles` and calculates an RDPG.

# Arguments
- `date::Date`: date of embedding.
- `kw::String`: keyword of embedding.
"""
function get_base_rdpg(date::Date,kw::String)
    df = query_postgres("processedarticles", "back", condition = replace("where date='$(date)' and keyword='$(kw)'", "\""=>""))
    A = df.embedding[1]'*df.embedding[1]
    A = set_max.(A, [1.0])
    A = set_min.(A, [0.0])
end

