module DisplayAs

struct Showable{MT <: MIME}
    mime::MT
    content
end

Showable{mime}(content) where {mime <: MIME} = Showable(mime(), content)

Base.show(io::IO, ::mime, s::Showable{mime}) where mime <: MIME =
    show(io, mime(), s.content)

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

const Text = Showable{MIME"text/plain"}
const MD = Showable{MIME"text/markdown"}
const HTML = Showable{MIME"text/html"}
const JSON = Showable{MIME"application/json"}
const SVG = Showable{MIME"image/svg+xml"}
const PNG = Showable{MIME"image/png"}
const PDF = Showable{MIME"application/pdf"}
const EPS = Showable{MIME"application/eps"}
const JPEG = Showable{MIME"image/jpeg"}
const PS = Showable{MIME"application/postscript"}
const LaTeX = Showable{MIME"text/latex"}

end # module
