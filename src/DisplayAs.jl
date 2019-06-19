@doc let path = joinpath(dirname(@__DIR__), "README.md")
    include_dependency(path)
    replace(read(path, String), "```julia" => "```jldoctest")
end ->
module DisplayAs

_showables = [
    (:Text, "text/plain")
    (:MD, "text/markdown")
    (:HTML, "text/html")
    (:JSON, "application/json")
    (:SVG, "image/svg+xml")
    (:PNG, "image/png")
    (:PDF, "application/pdf")
    (:EPS, "application/eps")
    (:JPEG, "image/jpeg")
    (:PS, "application/postscript")
    (:LaTeX, "text/latex")
    (:CSV, "text/csv")
    (:TSV, "text/tab-separated-values")
]

"""
    Showable{mime <: MIME}

# Examples
```jldoctest
julia> using DisplayAs

julia> DisplayAs.Showable{MIME"text/html"} === DisplayAs.HTML
true

julia> using Markdown

julia> md = Markdown.parse("hello");

julia> showable("text/html", md)
true

julia> showable("text/markdown", md)
true

julia> showable("text/html", DisplayAs.HTML(md))
true

julia> showable("text/markdown", DisplayAs.HTML(md))
false

julia> showable("text/html", DisplayAs.MD(md))
false

julia> showable("text/markdown", DisplayAs.MD(md))
true
```
"""
struct Showable{mime <: MIME}
    content
end

# Following method introduces method ambiguities with `Base` and
# `DelimitedFiles`:
#=
Base.show(io::IO, ::mime, s::Showable{mime}) where mime <: MIME =
    show(io, mime(), s.content)
=#

for (_, mime) in _showables
    MIMEType = typeof(MIME(mime))
    @eval Base.show(io::IO, ::$MIMEType, s::Showable{$MIMEType}) =
        show(io, $MIMEType(), s.content)
end

"""
    mime"..." :: Type{<:Showable}

# Examples
```jldoctest
julia> using DisplayAs

julia> DisplayAs.mime"text/plain" === DisplayAs.Text
true
```
"""
macro mime_str(s)
    :(Showable{MIME{Symbol($s)}})
end

for (name, mime) in _showables
    doc = """
        DisplayAs.$name(x)

    Wrap an object `x` in another object that prefers to be displayed as
    MIME type $mime.  That is to say, `display(DisplayAs.$name(x))` is
    equivalent to `display("$mime", x)` (except some corner cases).

    See also [`Showable`](@ref).
    """
    @eval @doc $doc const $name = @mime_str $mime
end

"""
    Unlimited

Unlimit display size.  Useful for, e.g., printing all contents of
dataframes in a Jupyter notebook.

# Examples
```
julia> using DisplayAs, VegaDatasets

julia> data = dataset("cars");

julia> data |> DisplayAs.Unlimited
```
"""
struct Unlimited
    content
end

Base.showable(::MIME{mime}, x::Unlimited) where {mime} =
    hasmethod(show, Tuple{IO, MIME{mime}, typeof(x)}) &&
    showable(MIME(mime), x.content)

unlimit(io) = IOContext(
    io,
    :compact => false,
    :limit => false,
    :displaysize => (typemax(Int), typemax(Int)),
)

_textmimes = [m for (_, m) in _showables if startswith(m, "text/")]
_textmimes = [
    _textmimes
    # from multimedia.jl:
    "application/atom+xml"
    "application/ecmascript"
    "application/javascript"
    "application/julia"
    "application/json"
    "application/postscript"
    "application/rdf+xml"
    "application/rss+xml"
    "application/x-latex"
    "application/xhtml+xml"
    "application/xml"
    "application/xml-dtd"
    "image/svg+xml"
    "model/vrml"
    "model/x3d+vrml"
    "model/x3d+xml"
]

for mime in _textmimes
    mimetype = MIME{Symbol(mime)}
    @eval Base.show(io::IO, ::$mimetype, obj::Unlimited) =
        show(unlimit(io), $mimetype(), obj.content)
end

end # module
