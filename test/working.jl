using CSV
using DataFrames

df = CSV.read("../dados/edges_reduced.csv")|> DataFrame

ne = 
