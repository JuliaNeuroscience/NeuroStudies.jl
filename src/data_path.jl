
@enum AssociatedData::UInt8 code sourcedata rawdata stimuli derivatives phenotype home
Base.String(x::AssociatedData) = String(Symbol(x))

"""
    DataPath(parent::NeuroStudy, basename::AssociatedData)

Represents a path to `basename` assocciated with `parent`.
"""
struct DataPath <: AbstractNeuroPath
    parent::NeuroStudy
    basename::AssociatedData
end
(p::DataPath)(x::AbstractString) = SubjectPath(p, x)

@inline function Base.abspath(x::DataPath)
    b = getfield(x, :basename)
    if b === home
        return abspath(parent(x))
    else
        return joinpath(abspath(parent(x)), String(Symbol(b)))
    end
end
@inline function Base.basename(x::DataPath)
    b = getfield(x, :basename)
    if b === home
        return basename(parent(x))
    else
        return String(Symbol(b))
    end
end

Base.parent(x::DataPath) = getfield(x, :parent)

