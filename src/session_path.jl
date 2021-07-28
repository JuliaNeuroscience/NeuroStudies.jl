
"""
    SessionPath(parent::DataPath, label::String)

Represents a path to data `parent` associated with session `label`.
"""
struct SessionPath{L<:Union{String,Nothing}} <: AbstractPath
    parent::SubjectPath{String}
    label::L
end

(p::SessionPath)(label::String) = SessionPath(parent(p), label)

Base.parent(x::SessionPath) = getfield(x, :parent)

Base.basename(x::SessionPath) = "ses-" * getfield(x, :label)

Base.abspath(x::SessionPath) = joinpath(abspath(parent(x)), basename(x))

@inline function Base.getproperty(x::SessionPath, s::Symbol)
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
    elseif s === :init
        return Initializer(x)
    else
        return metadata(x, s)
    end
end

