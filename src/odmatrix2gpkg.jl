function odm2gpkg(odfile::String, vfile::String; outfile::String="od.gpkg")
    gpd = pyimport("geopandas")
    geom = pyimport("shapely.geometry")

    odm = CSV.read(odfile)
    nod = size(odm,1)
    vs = CSV.read(vfile)
    println(first(vs,3))
    println(first(odm,3))
    geometry = []
    value  = []
    outfrom = []
    for i = 1:nod
        o = odm[i,:orig]
        d = odm[i,:dest]
        olat = vs[o,:lat]
        olon = vs[o,:lon]
        dlat = vs[d,:lat]
        dlon = vs[d,:lon]
        push!(geometry,geom.LineString([(olat, olon),(dlat, dlon)]))
        push!(value, odm[i,:val])
        push!(outfrom, vs[o,:cname])
    end
    data = Dict("value" => value, "outfrom"=>outfrom)
    gdf = gpd.GeoDataFrame(data=data, geometry=geometry)
    gdf.to_file(outfile, layer="reduced", driver="GPKG")
    return true
end
