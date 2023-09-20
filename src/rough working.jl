process_todays_articles(999)
  

A = ones(Float64, (5000,200))

U, S, V =  fast_svd(A,5);


