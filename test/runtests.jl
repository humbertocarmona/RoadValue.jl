using RoadValue
using Test
RoadValue.greet()
println("working path = ", pwd())
vrfile = "../dados/vertices_reduced.csv"
erfile = "../dados/edges_reduced.csv"
vffile = "../dados/vertices_full.csv"
effile = "../dados/edges_full.csv"
odfile = "../dados/od_mat.csv" #have been checked, ok
g, distmx, textmx, eidic, location = RoadValue.reducedNet(vrfile, erfile)
valuemx = RoadValue.valueAssignment(g, distmx, odfile)
RoadValue.full2gpkg(erfile,vffile, effile, distmx, eidic)
RoadValue.reduced2gpkg(g, location, distmx, textmx)

@testset "RoadValue" begin
	@test true
end
