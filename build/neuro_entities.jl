
module NeuroEntities

export Entity

@enum Entity::UInt8 begin
    acquisition
    label
    space
    flip
    reconstruction
    subject
    sample
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
    elseif x === sample
        return "sample"
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
    elseif x == "sample"
        return sample
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
        error(x * " cannot be converted to an Entity type.")    end
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
    elseif x == :sample
        return sample
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

end