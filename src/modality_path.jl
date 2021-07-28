
@enum Modality::Int8 anat beh dwi eeg fmap func ieeg meg perf pet

Base.String(x::Modality) = String(Symbol(x))

"""
    ModalityPath(p::SubjectPath, m::Modality)

Represents a path to a modality directory `m` for a subject path `p`.
"""
struct ModalityPath{P<:Union{SubjectPath{String},SessionPath{String}}}
    parent::P
    modality::Modality
end

const SubjectModality = ModalityPath{SubjectPath{String}}

const SessionModality = ModalityPath{SessionPath{String}}

Base.basename(x::ModalityPath) = String(getfield(x, :modality))

Base.abspath(x::ModalityPath) = joinpath(abspath(parent(x)), basename(x))

Base.parent(x::ModalityPath) = getfield(x, :parent)

@inline function (m::ModalityPath)(@nospecialize suffix::AbstractString; kwargs...)
    me = getfield(m, :modality)
    sub = getfield(getfield(m, :subject), :label)
    if me === anat
        return NeuroPath(m, _anat_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    elseif me === dwi
        return NeuroPath(m, _dwi_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    elseif s === :eeg
        return NeuroPath(m, _eeg_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    elseif s === :fmap
        return NeuroPath(m, _fmap_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    elseif s === :func
        return NeuroPath(m, _func_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    elseif s === :ieeg
        return NeuroPath(m, _ieeg_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    elseif s === :meg
        return NeuroPath(m, _meg_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    elseif s === :perf
        return NeuroPath(m, _perf_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    elseif s === :pet
        return NeuroPath(m, _pet_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    else # s === :beh 
        return NeuroPath(m, _beh_file(suffix, NeuroStudyCore.entities(; subject=sub, kwargs...)))
    end
end

