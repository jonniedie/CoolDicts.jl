"""
    Dict([itr])

    Dict{V}()

Like a normal `Dict`, but cool. Values are settable and gettable through dot notation as
well as standard `Dict` indexing notation. The only additional restriction is that keys must
be `Symbolic`.

# Examples
```julia-repl
julia> a = CoolDict();

julia> a.a = 1;

julia> a.b = "howdy";

julia> a
CoolDict{Symbol,Any} with 2 entries:
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
    for (key, val) in zip(keys(cd), values(cd))
        println(io, "  :$key => " * decorated_string(val))
    end
    return nothing
end

Base.length(cd::CoolDict) = length(cd._data)
Base.iterate(cd::CoolDict, args...; kwargs...) = iterate(cd._data, args...; kwargs...)

Base.getindex(cd::CoolDict, key) = getfield(cd, :_data)[key]
Base.setindex!(cd::CoolDict, value, key) = (cd._data[key] = value)

function Base.getproperty(cd::CoolDict, key::Symbol)
    if key == :_data
        return getfield(cd, :_data)
    elseif key in keys(cd)
        return getfield(cd, :_data)[key]
    else
        return error("type CoolDict has no field $key")
    end
end
Base.setproperty!(cd::CoolDict, key::Symbol, value) = (cd._data[key] = value)

Base.keys(cd::CoolDict) = keys(cd._data)
Base.values(cd::CoolDict) = values(cd._data)

Base.convert(::Type{Dict}, cd::CoolDict) = cd._data
Base.convert(::Type{Tuple}, cd::CoolDict) = Tuple(cd._data)
Base.convert(::Type{NamedTuple}, cd::CoolDict) = (; cd._data...)
Base.NamedTuple(cd::CoolDict) = convert(NamedTuple, cd)
