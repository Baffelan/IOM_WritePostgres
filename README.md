# WritePostgres

[![Build Status](https://github.com/StirlingSmith/WritePostgres.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/StirlingSmith/WritePostgres.jl/actions/workflows/CI.yml?query=branch%3Amain)
## Structure
This package is structured to allow for  simple workflows for connecting to both the forward facing, and back facing postgres databases. Additionally it allows for simple processing of daily collections of articles.

The main function is `process_articles`. This function reads in raw articles within a given date range, processes them and stores them in the `processedarticle` database. 

`process_articles` is then broadly broken down into `set_up_inputs` and `create_processed_df`.
## Installation and Setup
To use this package, the package `WritePostgres.jl` must first be installed.
```julia
using Pkg

Pkg.add("https://github.com/Baffelan/WritePostgres")
```

# Config
This package uses environment variables to access remote postgreSQL servers.

The required environment variables are:
```
IOMFRNTDB="Forward_Facing_DataBase_Name"
IOMFRNTUSER="User1"
IOMFRNTPASSWORD="User1_password"
IOMFRNTHOST="Forward_Facing_Host_Address"
IOMFRNTPORT="Forward_Facing_Port"

IOMBCKDB="Back_Facing_DataBase_Name"
IOMBCKUSER="User2"
IOMBCKPASSWORD="User2_password"
IOMBCKHOST="Back_Facing_Host_Address"
IOMBCKPORT="Back_Facing_Port"

NEWSAPIKEY="API_KEY"
```

Additional environment variables when using `process_todays_articles` are:
```
IOMALIGNMENTTOKENS=["word1", "word2","word3",...]
IOMBURNINRANGE=[[start_date], [end_date]]
IOMEMBDIM="4"
```


## Work Flow

## Example script
to do
```julia
using JSON
using MakeWebJSON
using Dates




open("user_web_example.json", "w") do f
    write(f, JSON.json(j))
end



```
Note that the only function exported by MakeWebJSON is create_web_JSON.



## Exported Functions

```Julia

```