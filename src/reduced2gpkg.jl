function reduced2gpkg(g::SimpleGraph, locations::Vector{Tuple{Float64,Float64}},
                      distmx::Array{Float64, 2}, textmx, outfile::String = "reduced.gpkg")
    gpd = pyimport("geopandas")
    geom = pyimport("shapely.geometry")
    coords = [geom.Point(c) for c in locations]
    links = collect(edges(g))

    dist  = []
    textt = []
    geometry = []
    for e in links
        s = e.src
        d = e.dst
        push!(geometry, geom.LineString([coords[s],coords[d]]))
        push!(dist, distmx[s,d])
        push!(textt, textmx[s,d])
    end
    data = Dict("dist" => dist, "text"=> textt)
    gdf = gpd.GeoDataFrame(data=data, geometry=geometry)
    gdf.to_file(outfile, layer="reduced", driver="GPKG")

    return true
end
