using DisplayAs
using Test

struct PrintContext end
function Base.show(io::IO, ::MIME"text/plain", ::PrintContext)
    print(io, get(io, :compact, "-"), "/")
    print(io, get(io, :limit, "-"), "/")
    print(io, get(io, :displaysize, "-"))
end

@testset "DisplayAs.jl" begin
    @test showable("text/plain", DisplayAs.Text(nothing))
    @test showable("text/html", DisplayAs.HTML(nothing))
    @test showable("text/markdown", DisplayAs.MD(nothing))
    @test showable("image/png", DisplayAs.PNG(nothing))
    text_png = DisplayAs.Text(DisplayAs.PNG(nothing))
    @test showable("text/plain", text_png)
    @test showable("image/png", text_png)
    @test !showable("image/html", text_png)
    # IOContextCarrier
    iob = IOBuffer()
    ioc = IOContext(iob, :compact=>true, :limit=>true, :displaysize=>(24, 80))
    show(ioc, MIME"text/plain"(), PrintContext())
    @test String(take!(iob)) == "true/true/(24, 80)"
    show(ioc, MIME"text/plain"(), DisplayAs.IOContextCarrier(PrintContext()))
    @test String(take!(iob)) == "true/true/(24, 80)"
    show(ioc, MIME"text/plain"(), DisplayAs.IOContextCarrier(PrintContext(), :limit=>false))
    @test String(take!(iob)) == "true/false/(24, 80)"
    # Unlimited
    show(ioc, MIME"text/plain"(), DisplayAs.Unlimited(PrintContext()))
    @test String(take!(iob)) == "false/false/($(typemax(Int)), $(typemax(Int)))"
end

using Aqua
Aqua.test_all(DisplayAs)
