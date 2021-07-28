module NeuroStudyCore

@enum Entity::UInt8 begin
    acquisition
    label
    space
    flip
    reconstruction
    subject
    processing
    part
    split
    description
    tracer
    recording
    resolution
    direction
    session
    task
    mtransfer
    run
    modality
    density
    inversion
    ceagent
    echo
end

function Base.String(x::Entity)
    if x === acquisition
        return "acq"
    elseif x === label
        return "label"
    elseif x === space
        return "space"
    elseif x === flip
        return "flip"
    elseif x === reconstruction
        return "rec"
    elseif x === subject
        return "sub"
    elseif x === processing
        return "proc"
    elseif x === part
        return "part"
    elseif x === split
        return "split"
    elseif x === description
        return "desc"
    elseif x === tracer
        return "trc"
    elseif x === recording
        return "recording"
    elseif x === resolution
        return "res"
    elseif x === direction
        return "dir"
    elseif x === session
        return "ses"
    elseif x === task
        return "task"
    elseif x === mtransfer
        return "mt"
    elseif x === run
        return "run"
    elseif x === modality
        return "mod"
    elseif x === density
        return "den"
    elseif x === inversion
        return "inv"
    elseif x === ceagent
        return "ce"
    elseif x === echo
        return "echo"
    end
end

function Entity(x::AbstractString)
    if x == "acq"
        return acquisition
    elseif x == "label"
        return label
    elseif x == "space"
        return space
    elseif x == "flip"
        return flip
    elseif x == "rec"
        return reconstruction
    elseif x == "sub"
        return subject
    elseif x == "proc"
        return processing
    elseif x == "part"
        return part
    elseif x == "split"
        return split
    elseif x == "desc"
        return description
    elseif x == "trc"
        return tracer
    elseif x == "recording"
        return recording
    elseif x == "res"
        return resolution
    elseif x == "dir"
        return direction
    elseif x == "ses"
        return session
    elseif x == "task"
        return task
    elseif x == "mt"
        return mtransfer
    elseif x == "run"
        return run
    elseif x == "mod"
        return modality
    elseif x == "den"
        return density
    elseif x == "inv"
        return inversion
    elseif x == "ce"
        return ceagent
    elseif x == "echo"
        return echo
    else
        error(x * " cannot be converted to an Entity type.")
    end
end

function Entity(x::Symbol)
    if x == :acquisition
        return acquisition
    elseif x == :label
        return label
    elseif x == :space
        return space
    elseif x == :flip
        return flip
    elseif x == :reconstruction
        return reconstruction
    elseif x == :subject
        return subject
    elseif x == :processing
        return processing
    elseif x == :part
        return part
    elseif x == :split
        return split
    elseif x == :description
        return description
    elseif x == :tracer
        return tracer
    elseif x == :recording
        return recording
    elseif x == :resolution
        return resolution
    elseif x == :direction
        return direction
    elseif x == :session
        return session
    elseif x == :task
        return task
    elseif x == :mtransfer
        return mtransfer
    elseif x == :run
        return run
    elseif x == :modality
        return modality
    elseif x == :density
        return density
    elseif x == :inversion
        return inversion
    elseif x == :ceagent
        return ceagent
    elseif x == :echo
        return echo
    else
        error("$(x) cannot be converted to an Entity type.")
    end
end

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
end

function _anat_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "T1w" || suffix == "T2w" || suffix == "PDw" || suffix == "T2starw" || suffix == "FLAIR" || suffix == "inplaneT1" || suffix == "inplaneT2" || suffix == "PDT2" || suffix == "angio" || suffix == "T2star" || suffix == "FLASH" || suffix == "PD"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, part), suffix)
    elseif suffix == "T1map" || suffix == "T2map" || suffix == "T2starmap" || suffix == "R1map" || suffix == "R2map" || suffix == "R2starmap" || suffix == "PDmap" || suffix == "MTRmap" || suffix == "MTsat" || suffix == "UNIT1" || suffix == "T1rho" || suffix == "MWFmap" || suffix == "MTVmap" || suffix == "PDT2map" || suffix == "Chimap" || suffix == "S0map" || suffix == "M0map"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), suffix)
    elseif suffix == "defacemask"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, modality), suffix)
    elseif suffix == "MESE" || suffix == "MEGRE"
        return FileName(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, part), suffix)
    elseif suffix == "VFA"
        return FileName(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, flip), src, part), suffix)
    elseif suffix == "IRT1"
        return FileName(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, inversion), src, part), suffix)
    elseif suffix == "MP2RAGE"
        return FileName(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, inversion), src, part), suffix)
    elseif suffix == "MPM" || suffix == "MTS"
        return FileName(_get_opt(_get_req(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, mtransfer), src, part), suffix)
    elseif suffix == "MTR"
        return FileName(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, mtransfer), src, part), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _eeg_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "eeg"
        return FileName(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), suffix)
    elseif suffix == "channels"
        return FileName(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), suffix)
    elseif suffix == "coordsystem"
        return FileName(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, space), suffix)
    elseif suffix == "electrodes"
        return FileName(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, space), suffix)
    elseif suffix == "events"
        return FileName(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), suffix)
    elseif suffix == "photo"
        return FileName(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _perf_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "asl" || suffix == "m0scan"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, reconstruction), src, direction), src, run), suffix)
    elseif suffix == "aslcontext"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, reconstruction), src, direction), src, run), suffix)
    elseif suffix == "asllabeling"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, reconstruction), src, run), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _pet_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "pet"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, task), src, tracer), src, reconstruction), src, run), suffix)
    elseif suffix == "blood"
        return FileName(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, task), src, tracer), src, reconstruction), src, run), src, recording), suffix)
    elseif suffix == "events"
        return FileName(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, tracer), src, reconstruction), src, run), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _dwi_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "dwi"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, direction), src, run), src, part), suffix)
    elseif suffix == "sbref"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, direction), src, run), src, part), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _beh_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "stim" || suffix == "physio"
        return FileName(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), src, recording), suffix)
    elseif suffix == "events" || suffix == "beh"
        return FileName(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _meg_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "meg"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), src, processing), src, split), suffix)
    elseif suffix == "headshape"
        return FileName(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), suffix)
    elseif suffix == "markers"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, space), suffix)
    elseif suffix == "coordsystem"
        return FileName(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), suffix)
    elseif suffix == "channels"
        return FileName(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), src, processing), suffix)
    elseif suffix == "events"
        return FileName(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), suffix)
    elseif suffix == "photo"
        return FileName(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _fmap_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "phasediff" || suffix == "phase1" || suffix == "phase2" || suffix == "magnitude1" || suffix == "magnitude2" || suffix == "magnitude" || suffix == "fieldmap"
        return FileName(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, run), suffix)
    elseif suffix == "epi" || suffix == "m0scan"
        return FileName(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, ceagent), src, direction), src, run), suffix)
    elseif suffix == "TB1DAM"
        return FileName(_get_opt(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, flip), src, inversion), src, part), suffix)
    elseif suffix == "TB1EPI"
        return FileName(_get_opt(_get_opt(_get_req(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, inversion), src, part), suffix)
    elseif suffix == "TB1AFI" || suffix == "TB1TFL" || suffix == "TB1RFM" || suffix == "RB1COR"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, inversion), src, part), suffix)
    elseif suffix == "TB1SRGE"
        return FileName(_get_opt(_get_req(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, inversion), src, part), suffix)
    elseif suffix == "TB1map" || suffix == "RB1map"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _func_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "bold" || suffix == "cbv" || suffix == "sbref"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, ceagent), src, reconstruction), src, direction), src, run), src, echo), src, part), suffix)
    elseif suffix == "phase"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, ceagent), src, reconstruction), src, direction), src, run), src, echo), suffix)
    elseif suffix == "events"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, ceagent), src, reconstruction), src, direction), src, run), suffix)
    elseif suffix == "physio" || suffix == "stim"
        return FileName(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, ceagent), src, reconstruction), src, direction), src, run), src, recording), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _ieeg_file(suffix, @nospecialize(src::Tuple{Vararg{EntityPair}}))
    if suffix == "ieeg"
        return FileName(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), suffix)
    elseif suffix == "channels"
        return FileName(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), suffix)
    elseif suffix == "coordsystem"
        return FileName(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, space), suffix)
    elseif suffix == "electrodes"
        return FileName(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, space), suffix)
    elseif suffix == "events"
        return FileName(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), suffix)
    elseif suffix == "photo"
        return FileName(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), suffix)
    else
        error(suffix * " is not a supported suffix.")
    end
end

end
