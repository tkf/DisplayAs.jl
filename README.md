# DisplayAs

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tkf.github.io/DisplayAs.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tkf.github.io/DisplayAs.jl/dev)
[![Run tests](https://github.com/tkf/DisplayAs.jl/actions/workflows/test.yml/badge.svg)](https://github.com/tkf/DisplayAs.jl/actions/workflows/test.yml)
[![Codecov](https://codecov.io/gh/tkf/DisplayAs.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/tkf/DisplayAs.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![GitHub last commit](https://img.shields.io/github/last-commit/tkf/DisplayAs.jl.svg?style=social&logo=github)](https://github.com/tkf/DisplayAs.jl)

DisplayAs.jl provides functions to show objects in a chosen MIME type.

```julia
julia> using DisplayAs
       using Markdown

julia> md_as_html = Markdown.parse("hello") |> DisplayAs.HTML;

julia> showable("text/html", md_as_html)
true

julia> showable("text/markdown", md_as_html)
false

julia> md_as_md = Markdown.parse("hello") |> DisplayAs.MD;

julia> showable("text/html", md_as_md)
false

julia> showable("text/markdown", md_as_md)
true
```

It is also possible to use nesting in order to allow the object to be displayed
as multiple MIME types:

```julia
julia> md_as_html_or_text = Markdown.parse("hello") |> DisplayAs.HTML |> DisplayAs.Text;

julia> showable("text/html", md_as_html_or_text)
true

julia> showable("text/plain", md_as_html_or_text)
true

julia> showable("text/markdown", md_as_html_or_text)
false
```
