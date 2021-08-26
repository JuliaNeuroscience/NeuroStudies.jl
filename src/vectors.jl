
basename_type(x) = basename_type(typeof(x))
basename_type(::Type{P}) where {D,B,P<:NeuroPath{D,B}} = B

dirname_type(x) = dirname_type(typeof(x))
dirname_type(::Type{P}) where {D,B,P<:NeuroPath{D,B}} = D


similar_type(::Type{<:StudyPath}, ::Type{D}, ::Type{B}) where {D,B} = StudyPath{D,B}
similar_type(::Type{<:DerivativePath}, ::Type{D}, ::Type{B}) where {D,B} = DerivativePath{D,B}
similar_type(::Type{<:SessionPath}, ::Type{D}, ::Type{B}) where {D,B} = SessionPath{D,B}
similar_type(::Type{<:DataPath}, ::Type{D}, ::Type{B}) where {D,B} = DataPath{D,B}
similar_type(::Type{<:SubjectPath}, ::Type{D}, ::Type{B}) where {D,B} = SubjectPath{D,B}
similar_type(::Type{<:ModalityPath}, ::Type{D}, ::Type{B}) where {D,B} = ModalityPath{D,B}
similar_type(::Type{<:FilePath}, ::Type{D}, ::Type{B}) where {D,B} = FilePath{D,B}

# TODO """ ModalityIndicator """
Base.@kwdef struct ModalityIndicator <: AbstractVector{Modality}
    anat::Bool=false
    beh::Bool=false
    dwi::Bool=false
    fmap::Bool=false
    func::Bool=false
    perf::Bool=false
    pet::Bool=false
    eeg::Bool=false
    ieeg::Bool=false
    meg::Bool=false
end
@propagate_inbounds function Base.getindex(x::ModalityIndicator, i::Int)::Modality
    out = _get_indicator(x, i)
    @boundscheck out === nothing && throw(BoundsError(x, i))
    return getfield(out, 1)
end
function _get_indicator(x::ModalityIndicator, i::Int)
    if i === 1
        if getfield(x, i)
            return ModalityPath(nothing, "anat"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 2
        if getfield(x, i)
            return ModalityPath(nothing, "beh"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 3
        if getfield(x, i)
            return ModalityPath(nothing, "dwi"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 4
        if getfield(x, i)
            return ModalityPath(nothing, "fmap"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 5
        if getfield(x, i)
            return ModalityPath(nothing, "func"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 6
        if getfield(x, i)
            return ModalityPath(nothing, "perf"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 7
        if getfield(x, i)
            return ModalityPath(nothing, "pet"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 8
        if getfield(x, i)
            return ModalityPath(nothing, "eeg"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 9
        if getfield(x, i)
            return ModalityPath(nothing, "ieeg"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 10
        if getfield(x, i)
            return ModalityPath(nothing, "meg"), i
        else
            return _get_indicator(x, i+1)
        end
    else
        return nothing
    end
end

# TODO """ DerivativeIndicator """
Base.@kwdef struct DerivativeIndicator <: AbstractVector{Data}
    rawdata::Bool=false
    sourcedata::Bool=false
    stimuli::Bool=false
    derivatives::Bool=false
    phenotype::Bool=false
    code::Bool=false
end
@propagate_inbounds function Base.getindex(x::DerivativeIndicator, i::Int)::Data
    out = _get_indicator(x, i)
    @boundscheck out === nothing && throw(BoundsError(x, i))
    return getfield(out, 1)
end
function _get_indicator(x::DerivativeIndicator, i::Int)
    if i === 1
        if getfield(x, i)
            return DataPath(nothing, "rawdata"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 2
        if getfield(x, i)
            return DataPath(nothing, "sourcedata"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 3
        if getfield(x, i)
            return DataPath(nothing, "stimuli"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 4
        if getfield(x, i)
            return DataPath(nothing, "derivatives"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 5
        if getfield(x, i)
            return DataPath(nothing, "phenotype"), i
        else
            return _get_indicator(x, i+1)
        end
    elseif i === 6
        if getfield(x, i)
            return DataPath(nothing, "code"), i
        else
            return _get_indicator(x, i+1)
        end
    else
        return nothing
    end
end

function Base.iterate(x::Union{DerivativeIndicator,ModalityIndicator}, state=0)
    _get_indicator(x, state + 1)
end

# TODO """ PathVector """
struct PathVector{T,D,B} <: AbstractVector{T}
    dirname::D
    basenames::B

    function PathVector(dirname::D, basenames::AbstractVector{T}) where {D,T}
        new{similar_type(T, D, basename_type(T)),D,typeof(B)}(dirname, basenames)
    end
end

@inline function Base.iterate(x::PathVector)
    itr = iterate(getfield(x, :basenames))
    if itr === nothing
        return nothing
    else
        return (joinpath(dirname(x), getfield(itr, 1)), getfield(itr, 2))
    end
end
@inline function Base.iterate(x::PathVector, state)
    itr = iterate(getfield(x, :basenames), state)
    if itr === nothing
        return nothing
    else
        return (joinpath(dirname(x), getfield(itr, 1)), getfield(itr, 2))
    end
end

@propagate_inbounds function Base.getindex(x::PathVector, i::AbstractVector)
    @boundscheck checkbounds(getfield(x, :basenames), i)
    joinpath(dirname(x), @inbounds(getfield(x, :basenames)[i]))
end

@propagate_inbounds function Base.getindex(x::PathVector, i::Int)
    @boundscheck checkbounds(getfield(x, :basenames), i)
    joinpath(dirname(x), @inbounds(getfield(x, :basenames)[i]))
end

