module NeuroStudies

export NeuroStudy, ModalityPath, 

# TODO:
# - https://bids-specification.readthedocs.io/en/stable/99-appendices/10-file-collections.html
# - creating new file with similar entity names

include("core.jl")
using .NeuroStudyCore
using .NeuroStudyCore: FileName

abstract type AbstractNeuroPath end
(m::AbstractNeuroPath)(x::FileName, e=nothing) = NeuroPath(m, x, e)

include("neuro_study.jl")
include("data_path.jl")
include("subject_path.jl")
include("session_path.jl")
include("modality_path.jl")

# TODO SessionPath

"""
    NeuroPath(p::AbstractNeuroPath, b::FileName, e)

"""
struct FilePath{P<:AbstractPath,B<:Union{FileName,String},E<:Union{String,Nothing}} <: AbstractPath
    parent::P
    basename::B
    extension::E
end

Base.parent(x::NeuroPath) = getfield(x, :parent)
Base.abspath(x::NeuroPath) = joinpath(abspath(x), basename(x))
@inline function Base.basename(x::NeuroPath)
    e = getfield(x, :extension)
    if e === uninitialized
        return String(getfield(x, :basename))
    else
        return String(getfield(x, :basename)) * "." * String(e)
    end
end

## isdir
_isdir(x) = x, isdir(x)
_isdir(x::NeuroStudy) = _isdir(abspath(x))
@inline function _isdir(x::AbstractNeuroPath)
    p, switch = _isdir(parent(x))
    if switch
        return _isdir(joinpath(p, basename(x)))
    else
        return p, false
    end
end
@inline function Base.isdir(x::AbstractNeuroPath)
    p, switch = _isdir(parent(x))
    if switch
        return isdir(joinpath(p, basename(x)))
    else
        return false
    end
end

## isfile
Base.isfile(x::AbstractNeuroPath) = false
@inline function Base.isfile(x::NeuroPath)
    p, switch = _isdir(parent(x))
    if switch
        return isfile(joinapth(p, basename(x)))
    else
        return false
    end
end

struct Initializer{X}
    x::X
end

(init::Initializer)() = mkdir(abspath(getfield(init, :x)))
(init::Initializer{<:NeuroPath})() = touch(abspath(getfield(init, :x)))

#= TODO
function mkpath(path::AbstractString; mode::Integer = 0o777)
    isdirpath(path) && (path = dirname(path))
    dir = dirname(path)
    (path == dir || isdir(path)) && return path
    mkpath(dir, mode = checkmode(mode))
    try
        mkdir(path, mode = mode)
    catch err
        # If there is a problem with making the directory, but the directory
        # does in fact exist, then ignore the error. Else re-throw it.
        if !isa(err, IOError) || !isdir(path)
            rethrow()
        end
    end
    path
end

function Base.isdirpath end
=#

end
