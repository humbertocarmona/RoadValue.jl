using RoadValue
using Test
RoadValue.greet()
println("working path = ", pwd())
vrfile = "../dados/vertices_reduced.csv"
erfile = "../dados/edges_reduced.csv"
vffile = "../dados/vertices_full.csv"
effile = "../dados/edges_full.csv"
odfile = "../dados/od_mat.csv" #have been checked, ok

outfull = "../results/full.gpkg"
outreduced = "../results/reduced.gpkg"

g, distmx, jurmx, eidic, location = RoadValue.reducedNet(vrfile, erfile)
valuemx = RoadValue.valueAssignment(g, distmx, odfile)
RoadValue.full2gpkg(g,vffile, effile, valuemx, jurmx, eidic, outfile=outfull)
RoadValue.reduced2gpkg(g, location, valuemx, jurmx, outfile=outreduced)

@testset "RoadValue" begin
	@test true
end
