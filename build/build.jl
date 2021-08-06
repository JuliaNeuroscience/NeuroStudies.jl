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

function generate_entity_file(e)
    io = open("neuro_entities.jl", "w")
    write(io, "\n")

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
    close(io)
end

function generate_data_type_files(modalities, e)
    io = open("data_type_entities.jl", "w")
    # modalities
    for (m, v) in modalities
        write(io, "function _$(m)_entities(suffix, src::Entities)\n")
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
            write(io, "        return Entities($(str))\n")
        end
        write(io, "    else\n")
        write(io, "        error(suffix * \" is not a supported suffix.\")\n")
        write(io, "    end\n")
        write(io, "end\n\n")
    end
    close(io)
end

m, e = generate_schemas(["anat", "beh", "dwi", "eeg", "fmap", "func", "ieeg", "meg", "perf", "pet"]);

generate_entity_file(e)
generate_data_type_files(m, e)

