
Base.String(p::NeuroPath) = joinpath(String(dirname(p)), basename(p))

# repath
repath(p::StudyPath) = joinpath(dirname(p), basename(p))
repath(p::Study) = basename(p)

repath(p::DataPath) = joinpath(repath(p), basename(p))
repath(p::Data) = basename(p)

repath(p::SubjectPath) = joinpath(repath(p), basename(p))
repath(p::Subject) = basename(p)

repath(p::SessionPath) = joinpath(repath(p), basename(p))
repath(p::Session) = basename(p)

repath(p::ModalityPath) = joinpath(repath(p), basename(p))
repath(p::Modality) = basename(p)

repath(p::FilePath) = joinpath(repath(p), basename(p))
repath(p::File) = basename(p)

Base.basename(p::StudyPath) = getfield(p, :study)
Base.basename(p::DataPath) = getfield(p, :basename)
Base.basename(p::SubjectPath) = getfield(p, :subject)
Base.basename(p::SessionPath) = getfield(p, :session)
Base.basename(p::ModalityPath) = getfield(p, :modality)
Base.basename(p::FilePath) = getfield(p, :basename)
Base.basename(p::DerivativePath) = getfield(p, :pipeline)

Base.dirname(p::NeuroPath) = getfield(p, :dirname)
Base.dirname(p::NeuroPath{Nothing}) = ""

Base.splitpath(p::StudyPath) = (dirname(p), Study(basename(p)))
Base.splitpath(p::Study) = (p,)

Base.splitpath(p::DataPath) = (splitpath(dirname(p))..., Data(basename(p)))
Base.splitpath(p::Data) = (p,)

Base.splitpath(p::SubjectPath) = (splitpath(dirname(p))..., Subject(basename(p)))
Base.splitpath(p::Subject) = (p,)

Base.splitpath(p::SessionPath) = (splitpath(dirname(p))..., basename(p))
Base.splitpath(p::Session) = (p,)

Base.splitpath(p::ModalityPath) = (splitpath(dirname(p))..., Modality(basename(p)))
Base.splitpath(p::Modality) = (p,)

Base.joinpath(x::AbstractString, y::Study, z...) = joinpath(joinpath(x, y), z...)
Base.joinpath(x::NeuroPath, y, z...) = joinpath(joinpath(x, y), z...)
Base.joinpath(x::AbstractString, y::Study) = StudyPath(x, basename(y))
Base.joinpath(x::StudyPath, y::Data) = DataPath(x, basename(y))
Base.joinpath(x::StudyPath, y::Subject) = SubjectPath(x, basename(y))
Base.joinpath(x::Union{StudyPath,DataPath}, y::Subject) = SubjectPath(x, basename(y))
Base.joinpath(x::DataPath, y::Derivative) = DerivativePath(x, basename(y))
Base.joinpath(x::SubjectPath, y::Session) = SessionPath(x, basename(y))
Base.joinpath(x::Union{SubjectPath,SessionPath}, y::Modality) = ModalityPath(x, basename(y))
Base.joinpath(x::NeuroPath, y::File) = FilePath(x, basename(y))
@inline function Base.joinpath(x::ModalityPath, y::File)
    me = basename(x)
    if me === "anat"
        return _anat_file(x, y)
    elseif me === "dwi"
        return _dwi_file(x, y)
    elseif s === "eeg"
        return _eeg_file(x, y)
    elseif s === "fmap"
        return _fmap_file(x, y)
    elseif s === "func"
        return _func_file(x, y)
    elseif s === "ieeg"
        return _ieeg_file(x, y)
    elseif s === "meg"
        return _meg_file(x, y)
    elseif s === "perf"
        return _perf_file(x, y)
    elseif s === "pet"
        return _pet_file(x, y)
    else # s === :beh 
        return _beh_file(x, y)
    end
end

Base.splitext(p::NeuroPath) = splitext(basename(p))

Base.isdir(p::FilePath) = false
Base.isdir(p::NeuroPath) = isdir(repath(p))

Base.isfile(p::FilePath) = isfile(repath(p))
Base.isfile(p::NeuroPath) = false

Base.ispath(p::NeuroPath) = isdir(p)
Base.ispath(p::FilePath) = isfile(p)

Base.mkdir(p::NeuroPath) = mkdir(repath(p))

Base.touch(p::FilePath) = touch(repath(p))
Base.cp(x::NeuroPath, y::NeuroPath) = cp(repath(x), repath(y))
Base.mv(x::NeuroPath, y::NeuroPath) = mv(repath(x), repath(y))
Base.rm(p::NeuroPath) = rm((p))
Base.open(p::FilePath) = open(repath(p))
Base.open(p::FilePath, mode) = open(repath(p), mode)
Base.readdir(p::NeuroPath) = readdir(repath(p))
Base.read(p::FilePath) = read(repath(p))
Base.write(p::FilePath, data) = write(repath(p), data)

is_derivative(::Nothing) = false
is_derivative(p::StudyPath) = false
is_derivative(p::ModalityPath) = basename(p) === "derivatives"
is_derivative(p::NeuroPath) = is_derivative(dirname(p))

"""
    session(p::NeuroPath)
    session(s::AbstractString)

Return the session from a `NeuroPath` or compose a new instance of `SessionPath`.
"""
session(p::FilePath) = session(dirname(p))
session(p::ModalityPath) = session(dirname(p))
session(p::SessionPath) = p
session(p::AbstractString) = SessionPath(p)

"""
    subject(p::NeuroPath)
    subject(s::AbstractString)

Return the subject from a `NeuroPath` or compose a new instance of `SubjectPath`.
"""
subject(p::FilePath) = subject(dirname(p))
subject(p::ModalityPath) = subject(dirname(p))
subject(p::SessionPath) = subject(dirname(p))
subject(p::SubjectPath) = p
subject(p::AbstractString) = SubjectPath(p)

"""
    modality(p::NeuroPath)
    modality(s::AbstractString)

Return the modality from a `NeuroPath` or compose a new instance of `ModalityPath`.
"""
modality(p::ModalityPath) = p
modality(p::FilePath) = modality(dirname(p))
modality(p::AbstractString) = ModalityPath(p)


"""
    study(p::NeuroPath)
    study(s::AbstractString)

Return the study from a `NeuroPath` or compose a new instance of `StudyPath`.
"""
study(p::StudyPath) = p
study(p::NeuroPath) = studydir(dirname(p))
study(p::AbstractString) = StudyPath(p)

"""
    derivative(p::NeuroPath)
    derivative(s::AbstractString)

Return the derivative subpath from a `NeuroPath` or compose a new instance of `DerivativePath`.
"""
derivative(p::NeuroPath) = derivative(dirname(p))
derivative(p::DerivativePath) = p
derivative(p::AbstractString) = DerivativePath(p)


file(p::AbstractString) = FilePath(p)


Base.replace(p::SessionPath, s::Session) = SessionPath(dirname(p), basename(s))
Base.replace(p::ModalityPath, s::Session) = ModalityPath(replace(dirname(p), s), basename(p))
Base.replace(p::FilePath, s::Session) = FilePath(replace(dirname(p), s), basename(p))
## Derivative
function Base.relpath(p::DataPath{StudyPath{D}}, r::Derivative) where {D}
    DerivativePath(DataPath(dirname(p), "derivatives"), basename(r))
end
function Base.relpath(p::SubjectPath{StudyPath{D}}, r::Derivative) where {D}
    SubjectPath(DerivativePath(DataPath(dirname(p), "derivatives"), basename(r)), basename(p))
end
Base.relpath(p::SessionPath, r::Derivative) = SessionPath(relpath(dirname(p), r), basename(p))
Base.relpath(p::ModalityPath, r::Derivative) = ModalityPath(relpath(dirname(p), r), basename(p))
Base.relpath(p::FilePath, r::Derivative) = ModalityPath(relpath(dirname(p), r), basename(p))

## Subject
Base.relpath(p::SubjectPath, r::Subject) = SubjectPath(dirname(p), basename(r))
Base.relpath(p::SessionPath, r::Subject) = SessionPath(relpath(dirname(p), r), basename(p))
Base.relpath(p::ModalityPath, r::Subject) = ModalityPath(relpath(dirname(p), r), basename(p))
Base.relpath(p::FilePath, r::Subject) = FilePath(relpath(dirname(p), r), basename(p))

## Session
Base.relpath(p::SessionPath, r::Session) = SessionPath(dirname(p), basename(r))
Base.relpath(p::ModalityPath, r::Session) = ModalityPath(relpath(dirname(p), r), basename(p))
Base.relpath(p::FilePath, r::Session) = FilePath(relpath(dirname(p), r), basename(p))

## Modality
Base.relpath(p::ModalityPath, r::Modality) = ModalityPath(relpath(dirname(p), r), basename(p))
Base.relpath(p::FilePath, r::Modality) = ModalityPath(relpath(dirname(p), r), basename(p))

Base.mkpath(p::NeuroPath; mode::Integer = 0o777) = _mkpath(p, mode)
function _mkpath(x, mode)
    if !isdir(x)
        mkdir(x, mode)
    end
    return x
end
function _mkpath(x::NeuroPath, mode)
    pd = _mkpath(dirname(x), mode)
    pp = joinpath(p, basename(x))
    if !isdir(pp)
        mkdir(pp, mode)
    end
    return pp
end

