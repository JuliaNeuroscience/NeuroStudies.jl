
function each_subject(x::DataPath)
    out = String[]
    for (_, _, f) in walkdir(abspath(x))
        sf = split(f, "-")
        if first(sf) == "sub"
            push!(out, f)
        end
    end
    return out
end

"""
    SubjectPath(parent::DataPath, label::String)

Represents a path to data `parent` associated with subject `label`.
"""
struct SubjectPath{L<:Union{String,Nothing}} <: AbstractPath
    parent::DataPath
    label::L
end

(p::SubjectPath)(label::String) = SubjectPath(parent(p), label)

Base.parent(x::SubjectPath) = getfield(x, :parent)

Base.basename(x::SubjectPath) = "sub-" * getfield(x, :label)

Base.abspath(x::SubjectPath) = joinpath(abspath(parent(x)), basename(x))

@inline function Base.getproperty(x::SubjectPath, s::Symbol)
    if s === :dwi
        return ModalityPath(x, dwi)
    elseif s === :anat
        return ModalityPath(x, anat)
    elseif s === :eeg
        return ModalityPath(x, eeg)
    elseif s === :fmap
        return ModalityPath(x, fmap)
    elseif s === :func
        return ModalityPath(x, func)
    elseif s === :ieeg
        return ModalityPath(x, ieeg)
    elseif s === :meg
        return ModalityPath(x, meg)
    elseif s === :perf
        return ModalityPath(x, perf)
    elseif s === :pet
        return ModalityPath(x, pet)
    elseif s === :beh 
        return ModalityPath(x, beh)
    elseif s === :session
        return SessionPath(x)
    elseif s === :init
        return Initializer(x)
    else
        return metadata(x, s)
    end
end


# TODO scans_file
# https://bids-specification.readthedocs.io/en/stable/03-modality-agnostic-files.html#scans-file

