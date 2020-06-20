"""
    CoolDict(;kwargs...)

    CoolDict{V}()

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
```

See also: [`Dict`](@ref).
"""
struct CoolDict{V} <: AbstractDict{Symbol,V}
    _data::Dict{Symbol,V}
end
CoolDict(;kwargs...) = CoolDict(Dict(kwargs...))
CoolDict() = CoolDict(Dict{Symbol,Any}())


function Base.show(io::IO, cd::CoolDict{V}) where {V}
    println(io, "CoolDict{$V} with $(length(cd)) entries:")
    for (key, val) in cd
        println(io, "  :$key => " * decorated_string(val))
    end
    return nothing
end

@inline _getdata(cd) = getfield(cd, :_data)

Base.length(cd::CoolDict) = length(_getdata(cd))
Base.iterate(cd::CoolDict, args...; kwargs...) = iterate(_getdata(cd), args...; kwargs...)

@inline Base.getindex(cd::CoolDict, key) = _getdata(cd)[key]
@inline function Base.setindex!(cd::CoolDict, value, key)
    data = _getdata(cd)
    data[key] = value
end

Base.getproperty(cd::CoolDict, key::Symbol) = getindex(cd, key)
Base.setproperty!(cd::CoolDict, key::Symbol, value) = setindex!(cd, value, key)

Base.keys(cd::CoolDict) = keys(_getdata(cd))
Base.values(cd::CoolDict) = values(_getdata(cd))

Base.convert(::Type{Dict}, cd::CoolDict) = _getdata(cd)
Base.convert(::Type{Tuple}, cd::CoolDict) = Tuple(_getdata(cd))
Base.convert(::Type{NamedTuple}, cd::CoolDict) = (; _getdata(cd)...)
Base.NamedTuple(cd::CoolDict) = convert(NamedTuple, cd)
