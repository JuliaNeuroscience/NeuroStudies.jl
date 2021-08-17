
function _entity_name(s::String)
    if s === "acq"
        return s, true
    elseif s === "label"
        return s, true
    elseif s === "space"
        return s, true
    elseif s === "flip"
        return s, true
    elseif s === "rec"
        return s, true
    elseif s === "sub"
        return s, true
    elseif s === "sample"
        return s, true
    elseif s === "proc"
        return s, true
    elseif s === "part"
        return s, true
    elseif s === "split"
        return s, true
    elseif s === "desc"
        return s, true
    elseif s === "trc"
        return s, true
    elseif s === "recording"
        return s, true
    elseif s === "res"
        return s, true
    elseif s === "dir"
        return s, true
    elseif s === "ses"
        return s, true
    elseif s === "task"
        return s, true
    elseif s === "mt"
        return s, true
    elseif s === "run"
        return s, true
    elseif s === "mod"
        return s, true
    elseif s === "den"
        return s, true
    elseif s === "inv"
        return s, true
    elseif s === "ce"
        return s, true
    elseif s === "echo"
        return s, true
    else
        return s, false
    end
end

struct Entity
    entity::String
    label::String

    global _unsafe_entity(e::String, l::String) = new(e, l)

    function Entity(e::String, l::String)
        e, check = _entity_name(e)
        check || error("$e is not a valid entity.")
        return _unsafe_entity(e, l)
    end
    Entity(e, l) = Entity(String(e), String(l))
    function Entity(s::AbstractString)
        ss = split(s, "-")
        length(ss) !== 2 && error("$s cannot be parsed to an entity.")
        return Entity(ss[1], ss[2])
    end
end

struct EntityBaseName
    entities::Vector{Entity}
    suffix::String
    extension::String

    EntityBaseName(e::Vector{Entity}, s::AbstractString, ex::AbstractString) = new(e, s, ex)
    function EntityBaseName(s::AbstractString)
        filename, extension = splitext(s)
        filename_split = split(filename, "_")
        N = length(filename_split)
        # FIXME should probably for no negativity here
        entities = Vector{Entity}(undef, N-1)
        @inbounds for i in 1:(N-1)
            entities[i] = Entity(filename_split[i])
        end
        return EntityBaseName(entities, @inbounds(filename_split[end]), extension)
    end
end

