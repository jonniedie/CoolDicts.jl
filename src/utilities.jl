
function decorated_string(val)
    if val isa String
        return "\"$val\""
    elseif val isa Char
        return "\'$val\'"
    elseif val isa Symbol
        return ":$val"
    else
        return string(val)
    end
end
