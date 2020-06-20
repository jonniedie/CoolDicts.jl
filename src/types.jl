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

See also: [`Dict`](@ref).
"""
struct CoolDict{V} <: AbstractDict{Symbol,V}
    _data::Dict{Symbol,V}
    CoolDict(args...) = new{eltype(args).types[2]}(Dict(args...))
    CoolDict{V}(args...) where {V} = new{V}(Dict(args...))
    CoolDict() = new{Any}(Dict())
end

function Base.show(io::IO, cd::CoolDict{V}) where {V}
    println(io, "CoolDict{$V} with $(length(cd)) entries:")
    for (key, val) in cd
        println(io, "  :$key => " * decorated_string(val))
    end
    return nothing
end

_getdata(cd) = getfield(cd, :data)

Base.length(cd::CoolDict) = length(cd._data)
Base.iterate(cd::CoolDict, args...; kwargs...) = iterate(_getdata(cd), args...; kwargs...)

@inline Base.getindex(cd::CoolDict, key) = _getdata(cd)[key]
@inline function Base.setindex!(cd::CoolDict, value, key)
    data = _getdata(cd)
    data[key] = value
end

Base.getproperty(cd::CoolDict, key::Symbol) = _getdata(cd)[key]
Base.setproperty!(cd::CoolDict, key::Symbol, value) = setindex!(cd, value, key)

Base.keys(cd::CoolDict) = keys(_getdata(cd))
Base.values(cd::CoolDict) = values(_getdata(cd))

Base.convert(::Type{Dict}, cd::CoolDict) = _getdata(cd)
Base.convert(::Type{Tuple}, cd::CoolDict) = Tuple(_getdata(cd))
Base.convert(::Type{NamedTuple}, cd::CoolDict) = (; _getdata(cd)...)
Base.NamedTuple(cd::CoolDict) = convert(NamedTuple, cd)
