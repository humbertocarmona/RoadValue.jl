using CSV
using DataFrames
using LightGraphs


odm = CSV.read("../dados/od_mat.csv")
vs = CSV.read("../dados/vertices_reduced.csv")
nods = size(odm,1)
odnodes = odm[:,:org]
append!(odnodes,odm[:,:dst])
sort!(unique!(odnodes))

vdic = Dict{Int64, Int64}()
for i = 1:nvs
    vdic[odnodes[i]] = i
end

nvs = length(vdic)
g = SimpleGraph(nvs)

for i=1:nods
    k = odm[i,:org]
    l = odm[i,:dst]

    ok = add_edge!()
end
add_edge!(g,(3,4))
