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

## Problem
Given a temporal sequence of text ($W^t, \; \forall \; t \in 1\dots T$), we wish to identify anomalous days.

To do this, we create a relational network between the words ($w_1\dots w_K$) in $W^t$.

We define an edge at time $t$ ($w^t_{i} \leftrightarrow w^t_k$), to exist if $w_i, \,w_k$ occur together in at least one sentence in $W^t$.

We then decompose the matrix $W^t$ using a Singular Value Decomposition (SVD) to get the matrices $L^t, \, R^t$.

### What are we looking for?
We focus on detecting anomalies in the matrix $L^t$
$$
d^t = E(||L^t_{i,\cdot}-L^t_{k,\cdot}||_2) \quad \forall \space i, k
$$
The change in average distances from $t-1$ to $t$ is then
$$
D^t=||d^t-d^{t-1}||
$$
The distribution for these distances then is:
$$
E_D=E(D^t),\space V_D = V(D^t) \quad \forall \space t
$$

Then, for each pair of times $T+l, \, T+l-1$, we can calculate $D^{T+l}$ and check whether it lies in the MOE of $E_D, \, V_D$.

## Benchmarking
To create a benchmark for this algorithm, we generate a set of synthetic data from an observed network, and test the algorithm's ability to detect when the synthetic data has been randomised.

In this way we hope that the synthetic data is created from the same distribution as the real world process that created the original network.


### Sampling
To create our synthetic data, we make exploit a useful feature of the SVD is that we can readily construct a Random Dot Product Graph (RDPG). To do this we take
$$
X = L^t {R^t}' 
$$

$$
X=\left[\begin{array}{cccc}
    p_{1,1} & p_{1,2} & \dots     & p_{1,K} \\
    p_{2,1} & \ddots  &           & \vdots \\
    \vdots  &         &           &  p_{K-1,K}\\ 
    p_{K,1} & \dots   & p_{K,K-1} & p_{K,K}
    \end{array}\right]
$$

$$
p_{i,k} = \mathrm{P}(w^t_i\rightarrow w^t_k)
$$

A sample of $X$ can be readily found by running a Bernoulli trial on each entry of $X$ to find $x$.

$$
x_{i,k} \sim Bernoulli(p_{i,k})
$$



### Anomalies
To create anomalies in the synthetic data, we create a function XXXXX to randomly select a proportion ($e$) of the number of nodes in the network $(N)$ (rounded when necessary), and rewrite them. 

#### Set Value
When adding noise to a network, we randomly select $nN$ entries in the network and set them to 0, regardless of their previous value.

We then randomly select $nN$ different entries in the network and set them to 1, regardless of their previous value.

#### Swap Value
For this type of randomization, we select vertices in a similar way to the above, but instead of setting the entry $x_{i,j}$ to a specific value, we swap the value $x_{i,j}:=!x_{i,j}$.


### Baseline
At each noise level, we take 51 samples from the RDPG for 50 total distances. 

At every second time step we apply noise to the network $x$. This way we have samples of changing from one distribution (without noise) to another (with noise).

The distribution without noise can be viewed as a baseline.

Once we have a distribution for each noise level, we can see how likely they are to overlap with the baseline.


### Anomaly Detection


## Exported Functions

```Julia

```