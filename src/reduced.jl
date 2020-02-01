function reducedNet(vfile::String, efile::String)
    """
    Creates the simplified undirected road network:
    only cities connected by straight roads

    Arguments:
        nfile::String (input file for vertices)
        # lon, lat, ibge, v(full network index)

        efile::String (input file for edges)
        # orig, dest, km, jur
        # km: distance from one city to another
        # jur: juristiction state≡0 federal≡1


    Returns:
        g::SimpleGraph
        distmax::Array{Float} (distance matrix)
    """

    vs = CSV.read(vfile)
    es = CSV.read(efile) |> DataFrame

    nvs = size(vs, 1)  # number of vertices
    nes = size(es, 1)  # number od edges

    distmx = zeros(nvs, nvs) # distance matrix
    textmx = ["" for i=1:nvs, j=1:nvs]
    eidic = Dict() #need this dict because not all edges are added
    g = SimpleGraph(nvs)
    eid = 0
    for i = 1:nes
        o = es.orig[i]
        d = es.dest[i]
        dist = es.km[i]
        if add_edge!(g, o, d)
            eid += 1
            eidic[i] = eid  
            distmx[o, d] =  dist  # (1 - 0.5es.jur[i]) * federal have 50% less weight
            distmx[d, o] =  dist
            textmx[o, d] = "old=$i, new=$eid, $o<->$d, d=$dist"
            textmx[d, o] =  textmx[o, d]
        end
    end
    locations = collect(zip(vs.lat, vs.lon))
    return g, distmx, textmx, eidic, locations
end
