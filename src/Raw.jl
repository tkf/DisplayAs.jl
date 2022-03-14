module Raw

using ..DisplayAs: _showables

"""
    DisplayAs.Raw.Showable{mime}(bytes::Vector{UInt8})

An object that prints `bytes` for rendering `show` on `mime`; i.e., this object defines
`show(io::IO, ::mime, DisplayAs.Raw.Showable{mime}(bytes))` as `write(io, bytes)`.
"""
struct Showable{mime<:MIME}
    bytes::Vector{UInt8}
end

if VERSION >= v"1.7"
    Base.show(io::IO, ::mime, s::Showable{mime}) where {mime<:MIME} = write(io, s.bytes)
else
    for (_, mime) in _showables
        MIMEType = typeof(MIME(mime))
        @eval Base.show(io::IO, ::$MIMEType, s::Showable{>:$MIMEType}) =
            show(io, $MIMEType(), s.content)
    end
end

"""
    DisplayAs.Raw.mime"..." :: Type{<:Showable}

# Examples
```jldoctest
julia> using DisplayAs

julia> DisplayAs.Raw.mime"text/plain" === DisplayAs.Raw.Text
true
```
"""
macro mime_str(s)
    Showable{MIME{Symbol(s)}}
end

for (name, mime) in _showables
    doc = """
        DisplayAs.Raw.$name(bytes::Vector{UInt8})

    Wrap a pre-rendered `bytes` into an object that defines `show` for MIME type $mime.

    See also [`DisplayAs.Raw.Showable`](@ref).
    """
    @eval @doc $doc const $name = @mime_str $mime
end

end  # module Raw
