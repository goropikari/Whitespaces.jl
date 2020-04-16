# Whitespaces

[![Build Status](https://travis-ci.com/goropikari/Whitespaces.jl.svg?branch=master)](https://travis-ci.com/goropikari/Whitespaces.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/goropikari/Whitespaces.jl?svg=true)](https://ci.appveyor.com/project/goropikari/Whitespaces-jl)
[![Codecov](https://codecov.io/gh/goropikari/Whitespaces.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/goropikari/Whitespaces.jl)


```
julia> using Whitespaces

julia> ws = Whitespace("   \t  \t   \n\t\n     \t\t \t  \t\n\t\n  \n\n\n");

julia> compile!(ws)

julia> execute!(ws)
Hi
```
