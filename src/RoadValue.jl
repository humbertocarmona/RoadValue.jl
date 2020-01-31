module RoadValue
#After you push “Foo.jl” to github, others can install your package with
#sh> julia -e 'using Pkg; Pkg.add("https://github.com/your/Foo.jl")'
using DataFrames
using CSV
using LightGraphs
using PyCall

greet() = println("\n------\nHello this is the RoadValue package!\n------")

include("utils.jl")
include("reduced.jl")



export reducedNet


end # module
