using RoadValue
using Test
RoadValue.greet()
println("working path = ", pwd())
vfile = "../dados/network/simplified/vertices1.csv"
efile = "../dados/network/simplified/edges.csv"
odfile = "../dados/network/simplified/od_mat.csv" #have been checked, ok

g, distmx, textmx, loc = RoadValue.reducedNet(vfile, efile)
pmx = RoadValue.valueAssignment(g, distmx, odfile)
#
#
@testset "RoadValue" begin
	@test RoadValue.reduced2gpkg(g, loc, pmx, textmx)
end
