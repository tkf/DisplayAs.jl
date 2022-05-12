using DisplayAs
using Test

struct PrintOptions end
function Base.show(io::IO, ::MIME"text/plain", ::PrintOptions; options...)
    show(io, (; options...))
end

struct PrintContext end
function Base.show(io::IO, ::MIME"text/plain", ::PrintContext)
    print(io, get(io, :compact, "-"), "/")
    print(io, get(io, :limit, "-"), "/")
    print(io, get(io, :displaysize, "-"))
end

@testset "DisplayAs" begin
    @test showable("text/plain", DisplayAs.Text(nothing))
    @test showable("text/html", DisplayAs.HTML(nothing))
    @test showable("text/markdown", DisplayAs.MD(nothing))
    @test showable("image/png", DisplayAs.PNG(nothing))
    text_png = DisplayAs.Text(DisplayAs.PNG(nothing))
    @test showable("text/plain", text_png)
    @test showable("image/png", text_png)
    @test !showable("image/html", text_png)
    @test sprint(show, "text/plain", DisplayAs.Text(PrintOptions())) == repr(NamedTuple())
    @test sprint(show, "text/plain", DisplayAs.Text(PrintOptions(); a = 1)) ==
          repr((; a = 1))
    # (set|with)context
    iob = IOBuffer()
    ioc = IOContext(iob, :compact=>true, :limit=>true, :displaysize=>(24, 80))
    show(ioc, MIME"text/plain"(), PrintContext())
    @test String(take!(iob)) == "true/true/(24, 80)"
    show(ioc, MIME"text/plain"(), DisplayAs.setcontext(PrintContext()))
    @test String(take!(iob)) == "true/true/(24, 80)"
    show(ioc, MIME"text/plain"(), DisplayAs.withcontext()(PrintContext()))
    @test String(take!(iob)) == "true/true/(24, 80)"
    show(ioc, MIME"text/plain"(), DisplayAs.setcontext(PrintContext(), :limit=>false))
    @test String(take!(iob)) == "true/false/(24, 80)"
    show(ioc, MIME"text/plain"(), DisplayAs.withcontext(:limit=>false)(PrintContext()))
    @test String(take!(iob)) == "true/false/(24, 80)"
    # Unlimited
    show(ioc, MIME"text/plain"(), DisplayAs.Unlimited(PrintContext()))
    @test String(take!(iob)) == "false/false/($(typemax(Int)), $(typemax(Int)))"
end

@testset "DisplayAs.Raw" begin
    @testset "text/plain" begin
        io = IOBuffer()
        print(io, "hello")
        bytes = take!(io)
        s = DisplayAs.Raw.Text(bytes)
        @test showable("text/plain", s)
        @test sprint(show, "text/plain", s) == "hello"
    end
end

using Aqua
Aqua.test_all(DisplayAs)
