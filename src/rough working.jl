
ENV["IOMALIGNMENTTOKENS"]="""["is", "to", "for", "the", "and"]"""
ENV["IOMBURNINRANGE"]="""[]"""
ENV["IOMEMBDIM"]="4"
process_articles(999, [today()-Day(4), today()-Day(3)], false, JSON.parse(ENV["IOMALIGNMENTTOKENS"]),Date.(JSON.parse(ENV["IOMBURNINRANGE"])), parse(Int,ENV["IOMEMBDIM"]))