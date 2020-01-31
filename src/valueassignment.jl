function valueAssignment(g::SimpleGraph, distmx::Array{Float64, 2}, odfile::String)
    """
    assign values to roads based on money trade between cities
    Arguments:
        g::SimpleGraph -  reduced network created using reducedNet(..)
        distmx::Array{Float64, 2} -  distance between vertices
        odfile::String - path to file containg origin destination values - trade
        odmat: org,dst,ibge1,ibge2,val
    """

    # checked....
    # Fortaleza 1245
    # Sobral 1143 239km checado lat ln googlemaps
    # Juazeiro 1094 499Km checado com o googlemaps
    # Limoeiro 1226 ok
    # Maracanau 1159 ok
    # Poranga 1202 ok


    od = CSV.read(odfile)|>DataFrame # not mutable DataFrame add  |>DataFrame for mutablle
    select!(od, [:org, :dst, :val])
    nrows = size(od,1)
    valemx = zeros(size(distmx))

    f = 1
    while f < nrows
         sod = filter(row -> row[:org] == od[f, :org], od)
         n = size(sod,1)
         orig = sod[1,:org]
         dijk = dijkstra_shortest_paths(g, orig, distmx, allpaths=true)
         for d=1:n
             dest = sod[d,:dst]
             sv = dijk.predecessors[dest]
             havepath = size(sv,1) > 0
             if havepath
                 t = dest
                 s = sv[1]
                 while s != orig # loop through edges in shortest path
                     s = dijk.predecessors[t][1]

                     w = distmx[s,t]
                     valemx[s,t] += w
                     valemx[t,s] = valemx[s,t]
                     t = s
                 end
             elseif orig ≠ dest
                 println("no path, $orig <-> $dest")
             end
         end
         f += n
    end


    return valemx
end
