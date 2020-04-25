using Whitespaces
using Test

@testset "Whitespaces.jl" begin
    # Write your own tests here.
    hi = "   \t  \t   \n\t\n     \t\t \t  \t\n\t\n  \n\n\n"
    hi_ws = Whitespace(hi)
    compile!(hi_ws)
    res = sprint(io->execute!(io, hi_ws))
    @test res == "Hi"

    seven = Whitespace("   \t\t\t\n   \t\n\t   \t\n \t\n\n\n")
    compile!(seven)
    res = sprint(io->execute!(io, seven))
    @test res == "8"
end
