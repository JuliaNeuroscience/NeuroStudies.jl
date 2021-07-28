# This file is used to generate the "src/core.jl" file from the schema files in the BIDS
# specification. This should be run periodically to ensure that all entities are present and
# the rules for composing file names for each data type are BIDS compliant.
using YAML
using DataStructures

struct EntitySchema
    name::String
    entity::String
    description::String
end

struct ModalitySchema
    suffixes::Vector{String}
    extensions::Vector{String}
    entities::OrderedDict{Any,Any}
end

function generate_schemas(m::Vector{String})
    modalities = Dict{String,Vector{ModalitySchema}}()
    for m_i in m
        p = download("https://raw.githubusercontent.com/bids-standard/bids-specification/master/src/schema/datatypes/$(m_i).yaml")
        modalities[m_i] = [ModalitySchema(s["suffixes"], s["extensions"], s["entities"]) for s in YAML.load_file(p; dicttype=OrderedDict{Any,Any})]
    end
    entities = Dict{String,EntitySchema}()
    for (k,v) in YAML.load_file(download("https://raw.githubusercontent.com/bids-standard/bids-specification/master/src/schema/entities.yaml"); dicttype=OrderedDict{Any,Any})
        entities[k] = EntitySchema(k, v["entity"], v["description"])
    end
    return modalities, entities
end

function generate_entity_file(modalities, e)
    io = open("core.jl", "w")
    write(io, "\n")
    write(io, "module NeuroStudyCore\n\n")

    # Create enum for each entity 
    write(io, "@enum Entity::UInt8 begin\n")
    for (k,v) in e
        write(io, "    $(k)\n")
    end
    write(io, "end\n\n")

    # Entity -> String
    write(io, "function Base.String(x::Entity)\n")
    for (i, (k, v)) in enumerate(e)
        if i === 1
            write(io, "    if ")
        else
            write(io, "    elseif ")
        end
        write(io, "x === $(k)\n")
        write(io, "        return \"$(v.entity)\"\n")
    end
    write(io, "    end\n")
    write(io, "end\n\n")

    # String -> Entity
    write(io, "function Entity(x::AbstractString)\n")
    for (i, (k, v)) in enumerate(e)
        if i === 1
            write(io, "    if ")
        else
            write(io, "    elseif ")
        end
        write(io, "x == \"$(v.entity)\"\n")
        write(io, "        return $(k)\n")
    end
    write(io, "    else\n")
    write(io, "        error(x * \" cannot be converted to an Entity type.\")")
    write(io, "    end\n")
    write(io, "end\n\n")

    # Symbol -> Entity
    write(io, "function Entity(x::Symbol)\n")
    for (i, (k, v)) in enumerate(e)
        if i === 1
            write(io, "    if ")
        else
            write(io, "    elseif ")
        end
        write(io, "x == :$(k)\n")
        write(io, "        return $(k)\n")
    end
    write(io, "    else\n")
    write(io, "        error(\"\$(x) cannot be converted to an Entity type.\")\n")
    write(io, "    end\n")
    write(io, "end\n\n")
    write(io, """
    struct EntityPair
        entity::Entity
        label::String

        EntityPair(e::Entity, label) = new(e, string(label))
    end
    Base.String(x::EntityPair) = String(getfield(x, :entity)) * "-" * getfield(x, :label)

    function entities(; kwargs...)
        if length(kwargs) === 1
            return (EntityPair(Entity(first(keys(kwargs))), kwargs[1]),)
        else
            return (
                EntityPair(Entity(first(keys(kwargs))), kwargs[1]),
                entities(; kwargs[2:end]...)...
            )
        end
    end

    struct FileName
        entities::Tuple{Vararg{EntityPair}}
        suffix::String
    end
    @inline function Base.String(x::FileName)
        out = ""
        for e_i in getfield(x, :entities)
            out *= String(e_i)
            out *= "_"
        end
        return out * getfield(x, :suffix)
    end

    @inline function _get_opt(@nospecialize(dst), @nospecialize(src::Tuple{Vararg{EntityPair}}), e::Entity)
        for src_i in src
            getfield(src_i, :entity) === e && return (dst..., src_i)
        end
        return dst
    end

    @inline function _get_req(@nospecialize(dst), @nospecialize(src::Tuple{Vararg{EntityPair}}), e::Entity)
        for src_i in src
            getfield(src_i, :entity) === e && return (dst..., src_i)
        end
        error(String(e) * " is a required entity for the provided suffix.")
    end\n
    """)

    # modalities
    for (m, v) in modalities
        write(io, "function _$(m)_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))\n")
        for i in axes(v, 1)
            ms = v[i]
            if i === 1
                write(io, "    if ")
            else
                write(io, "    elseif ")
            end
            suffixes = ms.suffixes
            for j in axes(suffixes, 1)
                if j !== 1
                    write(io, " || ")
                end
                write(io, "suffix == \"$(suffixes[j])\"")
            end
            write(io, "\n")
            str = "()"
            for (k,v) in ms.entities
                if v == "required"
                    str = "_get_req($(str), src, $(k))"
                else
                    str = "_get_opt($(str), src, $(k))"
                end
            end
            write(io, "        return FileName($(str), suffix)\n")
        end
        write(io, "    else\n")
        write(io, "        error(suffix * \" is not a supported suffix.\")\n")
        write(io, "    end\n")
        write(io, "end\n\n")
    end
    write(io, "end")
    close(io)
end

m, e = generate_schemas(["anat", "beh", "dwi", "eeg", "fmap", "func", "ieeg", "meg", "perf", "pet"]);

generate_entity_file(m, e)

#generate_modality_file(m, e)

