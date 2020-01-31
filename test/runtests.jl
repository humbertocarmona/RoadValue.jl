using RoadValue
using Test
RoadValue.greet()
println(pwd())
vfile = "../dados/network/simplified/vertices.csv"
efile = "../dados/network/simplified/edges.csv"
rd, distmx, loc = reducedNet(vfile, efile)

RoadValue.reduced2gpkg(rd, loc)
@testset "RoadValue" begin
	@test RoadValue.reduced2gpkg(rd, loc)
end
