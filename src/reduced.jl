function reducedNet(nfile::String, efile::String)
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

    vs = CSV.read(nfile)
    es = CSV.read(efile) |> DataFrame  # now es is not const.

    nvs = size(vs, 1)  #number of vertices
    println(first(es,3))
    println(first(vs,3))

    distmx = zeros(nvs, nvs) # distance matrix
    textmx = ["" for i=1:nvs, j=1:nvs]
    g = SimpleGraph(nvs)

    es.km = maptorange(es.km)  # map to [0,1] interval
    for i = 1:size(es, 1)
        o = es.orig[i]
        d = es.dest[i]

        if add_edge!(g, o, d)
            distmx[o, d] =  (1 - 0.5es.jur[i])*es.km[i]  # (1 - 0.5es.jur[i]) * federal have 50% less weight
            distmx[d, o] =  distmx[o, d]
            textmx[o, d] = "$o:$(vs[!,:cname][o])<->$d:$(vs[!,:cname][d])  $(distmx[o, d])"
            textmx[d, o] =  textmx[o, d]
        end
    end
    location = collect(zip(vs.lat, vs.lon))
    return g, distmx, textmx, location
end
