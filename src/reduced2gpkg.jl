function reduced2gpkg(g::SimpleGraph, locations::Vector{Tuple{Float64,Float64}},
                      distmx::Array{Float64, 2}, textmx, outfile::String = "test.gpkg")

    gpd = pyimport("geopandas")
    geom = pyimport("shapely.geometry")
    coords = [geom.Point(c) for c in locations]
    links = collect(edges(g))

    dist  = []
    tt = []
    geometry = []
    ei = 1
    for e in links
        s = e.src
        d = e.dst
        ei += 1
        push!(geometry, geom.LineString([coords[s],coords[d]]))
        push!(dist, distmx[s,d])
        push!(tt, textmx[s,d])
    end
    data = Dict("dist" => dist, "eid"=> 1:size(links,1), "tt"=> tt)
    gdf = gpd.GeoDataFrame(data=data, geometry=geometry)
    gdf.to_file(outfile, layer="simplified road value", driver="GPKG")

    return true
end
