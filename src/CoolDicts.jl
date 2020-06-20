module CoolDicts

export CoolDict

"""
    x = CoolDict(args...; kwargs...)
    x = CoolDict{T}(args...; kwargs...)

Like a normal `Dict`, but cool. Values are settable and gettable through dot notation as
well as standard `Dict` indexing notation. The only additional restriction is that keys must
be `Symbolic`.

# Examples
```julia-repl
julia> x = CoolDict();

julia> x.a = 1;

julia> x.b = "howdy";

julia> x
CoolDict{Any} with 2 entries:
  :a => 1
  :b => "howdy"

julia> x.b
"howdy"

julia> y = CoolDict(a=5, b=5.5)
CoolDict{Real} with 2 entries:
  :a => 5
  :b => 5.5

julia> z = CoolDict{Float32}(a=40, b=1)
CoolDict{Float32} with 2 entries:
  :a => 40f0
  :b => 1f0
```

See also: [`Dict`](@ref).
"""
struct CoolDict{V} <: AbstractDict{Symbol,V}
    _data::Dict{Symbol,V}
end
CoolDict{T}(args...; kwargs...) where {T} = CoolDict(Dict{Symbol,T}(kwargs...))
CoolDict{T}() where {T} = CoolDict(Dict{Symbol,T}())
CoolDict(args...; kwargs...) = CoolDict(Dict(kwargs...))
CoolDict() = CoolDict(Dict{Symbol,Any}())


# Attribute access
@inline _getdata(cd) = getfield(cd, :_data)
Base.length(cd::CoolDict) = length(_getdata(cd))
Base.keys(cd::CoolDict) = keys(_getdata(cd))
Base.values(cd::CoolDict) = values(_getdata(cd))


# Use default `AbstractDict` show method normally, but show like a NamedTuple if inside an array or something
Base.show(io::IO, cd::CoolDict{T}) where {T} = print(io, "CoolDict{$T}$(NamedTuple(cd))")


# Iteration uses the internal Dict method
Base.iterate(cd::CoolDict, args...; kwargs...) = iterate(_getdata(cd), args...; kwargs...)


# Get/set index (i.e. cool_dict[:a] or cool_dict["a"])
@inline Base.getindex(cd::CoolDict, key::Symbol) = _getdata(cd)[key]
@inline Base.getindex(cd::CoolDict, key) = cd[Symbol(key)]

@inline function Base.setindex!(cd::CoolDict, value, key::Symbol)
    data = _getdata(cd)
    data[key] = value
end
@inline Base.setindex!(cd::CoolDict, value, key) = (cd[Symbol(key)] = value)


# Get/set properties (i.e. cool_dict.a)
Base.getproperty(cd::CoolDict, key::Symbol) = getindex(cd, key)
Base.setproperty!(cd::CoolDict, key::Symbol, value) = setindex!(cd, value, key)


# Conversion
Base.convert(::Type{Dict}, cd::CoolDict) = _getdata(cd)
Base.Dict(cd::CoolDict) = convert(Dict, cd)

Base.convert(::Type{Tuple}, cd::CoolDict) = Tuple(_getdata(cd))
Base.Tuple(cd::CoolDict) = convert(Tuple, cd)

Base.convert(::Type{NamedTuple}, cd::CoolDict) = (; _getdata(cd)...)
Base.NamedTuple(cd::CoolDict) = convert(NamedTuple, cd)

end # module
