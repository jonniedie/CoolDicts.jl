"""
    CoolDict([itr])

    CoolDict{V}()

Like a normal `Dict`, but cool. Values are settable and gettable through dot notation as
well as standard `Dict` indexing notation. The only additional restriction is that keys must
be `Symbolic`.

# Examples
```julia-repl
julia> a = CoolDict();

julia> a.a = 1;

julia> a.b = "howdy";

julia> a
CoolDict{Any} with 2 entries:
  :a => 1
  :b => "howdy"

julia> a.b
"howdy"
```

See also: [`Dict`, `NamedTuple`](@ref).
"""
struct CoolDict{V} <: AbstractDict{Symbol,V}
    _data::Dict{Symbol,V}
    CoolDict(dict::Dict{Symbol,V}) where {V} = new{V}(dict)
end
CoolDict() = CoolDict(Dict{Symbol, Any}())
CoolDict(args...) = CoolDict(Dict(args...))
CoolDict{V}(args...) where {V} = CoolDict(Dict{Symbol,V}(args...))
CoolDict{V}(cd::CoolDict) where {V} = CoolDict(Dict{Symbol,V}(getfield(cd, :_data)))
