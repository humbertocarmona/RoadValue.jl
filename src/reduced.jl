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
    distmx = zeros(nvs, nvs) # distance matrix
    g = SimpleGraph(nvs)

    es.km = maptorange(es.km)  # map to [0,1] interval
    for i = 1:size(es, 1)
        o = es.orig[i]
        d = es.dest[i]
        if add_edge!(g, o, d)
            distmx[o, d] = (1 - 0.5es.jur[i]) * es.km[i]  # federal have 50% less weight
        else
            f = has_edge(g, o, d)
            # @printf "problem %d %d %d\n" s d f
        end
    end
    location = collect(zip(vs.lat, vs.lon))
    return g, distmx, location
end


function reduced2gpkg(g::SimpleGraph, locations::Vector{Tuple{Float64,Float64}},
                      distmx::Array{Float64, 2}, outfile::String = "test.gpkg")

    gpd = pyimport("geopandas")
    geom = pyimport("shapely.geometry")
    coords = [geom.Point(c) for c in locations]
    links = collect(edges(g))

    dist  = []
    geometry = []
    for e in links
        s = e.src
        d = e.dst
        push!(geometry, geom.LineString([coords[s],coords[d]]))
        push!(dist, distmx[s,d])
    end

    data = Dict("dist" => dist, "eid"=> 1:size(links,1))
    gdf = gpd.GeoDataFrame(data=data, geometry=geometry)
    gdf.to_file(outfile, layer="simplified road value", driver="GPKG")

    return true
end
