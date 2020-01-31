function valueAssignment(g::SimpleGraph, distmx::Array{Float64, 2}, odfile::String)
    """
    assign values to roads based on money trade between cities
    Arguments:
        g::SimpleGraph -  reduced network created using reducedNet(..)
        distmx::Array{Float64, 2} -  distance between vertices
        odfile::String - path to file containg origin destination values - trade
    """

    od = CSV.read(odfile) # not mutable DataFrame add  |>DataFrame for mutablle

    # Fortaleza 1245
    # Sobral 1143 239km checado lat ln googlemaps
    # Juazeiro 1094 499Km checado com o googlemaps
    # Limoeiro 1226
    # Maracanau 1159
    # Poranga 1202

    orig = 1245
    dest = 1094

    pmx = zeros(size(distmx))

    dijk = dijkstra_shortest_paths(g, orig, distmx, allpaths=true)
    println("orig = $orig, dest = $dest")
    sv = dijk.predecessors[dest]

    havepath = size(sv,1) > 0
    distance = 0.0
    if havepath
        t = dest
        s = sv[1]
        while s != orig # loop through edges in shortest path
            s = dijk.predecessors[t][1]

            w = distmx[s,t]
            println("$t <= $s ...  $w")
            distance += w
            pmx[s,t] = 1.0
            pmx[t,s] = 1.0
            t = s
        end
    end
    println("distance = $distance  $(distmx[390,dest])")
    println("orig = $orig, dest = $dest")

    return pmx
end
