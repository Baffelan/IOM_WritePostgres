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


## Benchmarking
### Sampling
$$
X=\left[\begin{array}{cccc}
    p_{1,1} & p_{1,2} & \dots     & p_{1,n} \\
    p_{2,1} & \ddots  &           & \vdots \\
    \vdots  &         &           &  p_{n-1,n}\\ 
    p_{n,1} & \dots   & p_{n,n-1} & p_{n,n}
    \end{array}\right]
$$

$$
p_{i,j} = \mathrm{P}(i\rightarrow j)
$$

A sample of $X$ can be readily found by running a Bernoulli trial on each entry of $X$ to find $x$.

$$
x_{i,j} \sim Bernoulli(p_{i,j})
$$

### What are we looking for?
the anomaly detection algorithm looks to find large changes between networks from one time step to the next. To do this we TODO...
$$
L,R = SVD(x_t) \\
d_t = mean(||L_{i,\cdot}-L_{k,\cdot}||_2) \quad \forall \space i, k
$$
The distribution for these distances then is:
$$
mean(d_t),\space std(d_t) \quad \forall \space t
$$

### Noise
Noise $(n)$ is denoted as a percentage of the number of nodes in the network $(N)$ (rounded when necessary). 

When adding noise to a network, we randomly select $nN$ entries in the network and set them to 0, regardless of their previous value.

We then randomly select $nN$ different entries in the network and set them to 1, regardless of their previous value.

### Baseline
To get a baseline distribution we resample $X$ fifty-one times; this will give us fifty time steps to compare


### Anomaly Detection


## Exported Functions

```Julia

```