Base.length(cd::CoolDict) = length(getfield(cd, :_data))
Base.iterate(cd::CoolDict, args...; kwargs...) = iterate(getfield(cd, :_data), args...; kwargs...)

Base.getindex(cd::CoolDict, key) = getfield(cd, :_data)[key]
Base.setindex!(cd::CoolDict, value, key) = (getfield(cd, :_data)[key] = value)

Base.propertynames(cd::CoolDict) = Tuple(keys(cd))

function Base.getproperty(cd::CoolDict, key::Symbol)
    if key == :_data
        error("Hey, the $key field is sorta private. If you want to access it, you can use getfield(mycooldict, :$key) though. Sorry.")
    elseif key in keys(cd)
        return getfield(cd, :_data)[key]
    else
        return error("type CoolDict has no field $key")
    end
end
Base.setproperty!(cd::CoolDict, key::Symbol, value) = (getfield(cd, :_data)[key] = value)

Base.keys(cd::CoolDict) = keys(getfield(cd, :_data))
Base.values(cd::CoolDict) = values(getfield(cd, :_data))

Base.convert(T::Type{<:Dict}, cd::CoolDict) = T(getfield(cd, :_data))
Base.convert(::Type{NamedTuple}, cd::CoolDict) = (; getfield(cd, :_data)...)

function Base.show(io::IO, cd::CoolDict{V}) where {V}
    println(io, "CoolDict{$V} with $(length(cd)) entries:")
    for (key, val) in cd
        println(io, "  $key => " * decorated_string(val))
    end
    return nothing
end