using Documenter, DisplayAs

makedocs(;
    modules=[DisplayAs],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/tkf/DisplayAs.jl/blob/{commit}{path}#L{line}",
    sitename="DisplayAs.jl",
    authors="Takafumi Arakaki <aka.tkf@gmail.com>",
    strict=true,
)

deploydocs(;
    repo="github.com/tkf/DisplayAs.jl",
)
