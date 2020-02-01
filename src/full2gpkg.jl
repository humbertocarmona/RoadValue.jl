function full2gpkg(erfile::String, vffile::String, effile::String,
                   distmx::Array{Float64, 2}, eidic::Dict{Any,Any};
                   outfile::String = "full.gpkg")

    """
    Arguments:
        erfile - contains reduced net edges - orig,dest,km,jur
        effile - contains full net edges - orig,dest,redge(reduced edge)
        vffile - contains full net vertices - lon,lat,ibge
    """
    gpd = pyimport("geopandas")
    geom = pyimport("shapely.geometry")
    #----------------------------------------------------
    er = CSV.read(erfile)
    ef = CSV.read(effile)
    vf = CSV.read(vffile)

    nef = size(ef,1)
    dist = []
    geometry = []
    eid = []
    # first need to be treated separetly
    rold = ef[1,:redge]
    o = ef[1,:orig]
    d = ef[1,:dest]
    dlat = vf[d,:lat]
    dlon = vf[d,:lon]
    olat = vf[o,:lat]
    olon = vf[o,:lon]
    linestr = [(olat, olon), (dlat, dlon)]
    for i = 2:nef
        o = ef[i,:orig]
        d = ef[i,:dest]
        r = ef[i,:redge]
        dlat = vf[d,:lat]
        dlon = vf[d,:lon]
        olat = vf[o,:lat]
        olon = vf[o,:lon]
        if r == rold
            push!(linestr, (dlat, dlon))
        else
            if haskey(eidic, rold)
                j = eidic[rold]
                k = er[j,:orig]
                l = er[j,:dest]
                push!(dist, distmx[k,l])
            else
                push!(dist, -1.0)
            end
            push!(eid, rold)
            push!(geometry, geom.LineString(linestr))
            linestr = [(olat, olon), (dlat, dlon)]
        end
        rold = r
    end
    data = Dict("dist" => dist, "eid"=> eid)
    gdf = gpd.GeoDataFrame(data=data, geometry=geometry)
    gdf.to_file(outfile, layer="full", driver="GPKG")

    return true
end
