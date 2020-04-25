module Whitespaces
export Whitespace, compile!, execute!

include("lexer.jl")
include("vm.jl")

mutable struct Whitespace
    src::AbstractString
    insns::Vector
    stack::Vector
    heap::Dict
    labels::Dict

    function Whitespace(src)
        insns = Vector{Tuple{Symbol, String}}()
        stack = Vector{Int}()
        heap = Dict{Int, Int}()
        labels = Dict{AbstractString, Int}()
        new(src, insns, stack, heap, labels)
    end
end

function compile!(ws::Whitespace)
    ws.insns = tokenize(ws.src)
    nothing
end

function execute!(io, ws::Whitespace)
    ws.labels = find_labels(ws.insns)
    vm_execute!(io, ws)
end

execute!(ws::Whitespace) = execute!(stdout, ws)

end # module
