# WritePostgres

[![Build Status](https://github.com/StirlingSmith/WritePostgres.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/StirlingSmith/WritePostgres.jl/actions/workflows/CI.yml?query=branch%3Amain)
## Structure
This package is structured to allow for  simple workflows for connecting to both the forward facing, and back facing postgres databases. Additionally it allows for simple processing of daily collections of articles.

The main function is `process_articles`. This function reads in raw articles within a given date range, processes them and stores them in the `processedarticle` database. 

`process_articles` is then broadly broken down into `set_up_inputs` and `create_processed_df`.
## Installation and Setup


## Exported Functions

```Julia

```