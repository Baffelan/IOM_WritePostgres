"""
Processes the previous day's news articles into the processed table schema. For the sake of convenience, only the userID is required, and the function checks for the required ENV variables. Also writes the processed articles to the 'processedarticles' table. 

# Arguments
- 'userID::Int': user ID for the user being processed.
"""
function process_todays_articles(userID::Int)
    
    if haskey(ENV, "IOMALIGNMENTTOKENS")*haskey(ENV, "IOMBURNINRANGE") *haskey(ENV, "IOMEMBDIM")
        big_df = process_articles(userID, 
                                  [today()-Day(2),today()-Day(1)], 
                                  true,
                                  JSON.parse(ENV["IOMALIGNMENTTOKENS"]),
                                  Date.(JSON.parse(ENV["IOMBURNINRANGE"])), 
                                  parse(Int,ENV["IOMEMBDIM"]))

        load_processed_data(big_df[big_df.date .== today()-Day(1),:])

        return big_df[big_df.date .== today()-Day(1),:]
    else
        println("Missing some or all of environment variables: IOMALIGNMENTTOKENS, IOMBURNINRANGE, IOMEMBDIM")
    end


end
