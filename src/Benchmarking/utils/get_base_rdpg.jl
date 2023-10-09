set_max(n, m) = n>m ? m : n
set_min(n, m) = n<m ? m : n

function get_base_rdpg(date,kw)
    df = query_postgres("processedarticles", "back", condition = replace("where date='$(date)' and keyword='$(kw)'", "\""=>""))
    A = df.embedding[1]'*df.embedding[1]
    A = set_max.(A, [1.0])
    A = set_min.(A, [0.0])
end

