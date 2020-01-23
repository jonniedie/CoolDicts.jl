
struct CoolDict{S,T} <: AbstractDict{S,T}
    _data::Dict{S,T}
    CoolDict(args...) = new{Symbol, eltype(args).types[2]}(Dict(args...))
    CoolDict() = new{Symbol, Any}(Dict())
end

function Base.show(io::IO, cd::CoolDict{S,T}) where {S,T}
    println(io, "CoolDict{$S,$T} with $(length(cd)) entries:")
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

Base.convert(::Type{Tuple}, cd::CoolDict) = Tuple(cd._data)
Base.convert(::Type{NamedTuple}, cd::CoolDict) = (; a._data...)
Base.NamedTuple(cd::CoolDict) = convert(NamedTuple, cd)
