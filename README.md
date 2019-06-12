# DisplayAs

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tkf.github.io/DisplayAs.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tkf.github.io/DisplayAs.jl/dev)
[![Build Status](https://travis-ci.com/tkf/DisplayAs.jl.svg?branch=master)](https://travis-ci.com/tkf/DisplayAs.jl)
[![Codecov](https://codecov.io/gh/tkf/DisplayAs.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/tkf/DisplayAs.jl)
[![Coveralls](https://coveralls.io/repos/github/tkf/DisplayAs.jl/badge.svg?branch=master)](https://coveralls.io/github/tkf/DisplayAs.jl?branch=master)
[![Aqua QA](https://img.shields.io/badge/Aqua.jl-%F0%9F%8C%A2-aqua.svg)](https://github.com/tkf/Aqua.jl)
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
