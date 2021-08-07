
function _check_modality_name(s::String)
    if s === "anat"
        return nothing
    elseif s === "beh"
        return nothing
    elseif s === "dwi"
        return nothing
    elseif s === "fmap"
        return nothing
    elseif s === "func"
        return nothing
    elseif s === "perf"
        return nothing
    elseif s === "pet"
        return nothing
    elseif s === "eeg"
        return nothing
    elseif s === "ieeg"
        return nothing
    elseif s === "meg"
        return nothing
    else
        error("$s is not a valid modality directory name.")
    end
end

function _check_data_name(s::String)
    if s === "code"
        return nothing
    elseif s === "rawdata"
        return nothing
    elseif s === "sourcedata"
        return nothing
    elseif s === "stimuli"
        return nothing
    elseif s === "derivatives"
        return nothing
    elseif s === "phenotype"
        return nothing
    else
        error("$s is not a valid associated data directory name.")
    end
end

function _check_entity_name(s::String)
    if s === "acq"
        return nothing
    elseif s === "label"
        return nothing
    elseif s === "space"
        return nothing
    elseif s === "flip"
        return nothing
    elseif s === "rec"
        return nothing
    elseif s === "sub"
        return nothing
    elseif s === "sample"
        return nothing
    elseif s === "proc"
        return nothing
    elseif s === "part"
        return nothing
    elseif s === "split"
        return nothing
    elseif s === "desc"
        return nothing
    elseif s === "trc"
        return nothing
    elseif s === "recording"
        return nothing
    elseif s === "res"
        return nothing
    elseif s === "dir"
        return nothing
    elseif s === "ses"
        return nothing
    elseif s === "task"
        return nothing
    elseif s === "mt"
        return nothing
    elseif s === "run"
        return nothing
    elseif s === "mod"
        return nothing
    elseif s === "den"
        return nothing
    elseif s === "inv"
        return nothing
    elseif s === "ce"
        return nothing
    elseif s === "echo"
        return nothing
    else
        error("$s is not an entity.")
    end
end

struct Entity
    entity::String
    label::String

    Entity(e::String, l::String) = (_check_entity_name(e); new(e, l))
    Entity(e, l) = Entity(String(e), String(l))
    function Entity(s::AbstractString)
        ss = split(s, "-")
        length(ss) !== 2 && error("$s cannot be parsed to an entity.")
        return Entity(ss[1], ss[2])
    end
end

abstract type NeuroPath{D} end

struct StudyPath{D} <: NeuroPath{D}
    dirname::D
    study::String

    StudyPath(d::Union{Nothing,String}, s::String) = new{typeof(d)}(d, s)
    StudyPath(d, s::AbstractString) = StudyPath(d, String(s))
    StudyPath(s) = StudyPath(nothing, s)
end

struct DataPath{D} <: NeuroPath{D}
    dirname::D
    basename::String

    function DataPath(d::Union{Nothing,StudyPath}, s::String)
        _check_data_name(s)
        new{typeof(d)}(d, s)
    end
    DataPath(d::Union{Nothing,StudyPath}, s) = DataPath(d, String(s))
    DataPath(s) = DataPath(nothing, s)
end

struct DerivativePath{D} <: NeuroPath{D}
    dirname::D
    pipeline::String

    DerivativePath(::Nothing, s::String) = new{Nothing}(nothing, s)
    function DerivativePath(d::DataPath, s::String)
        @assert basename(d) === "derivatives"
        return new{typeof(d)}(d, s)
    end
    DerivativePath(d, s::AbstractString) = DerivativePath(d, String(s))
    DerivativePath(s) = DerivativePath(nothing, s)
end

"""
    SubjectPath

Represents a path to data `parent` associated with subject `label`.
"""
struct SubjectPath{D} <: NeuroPath{D}
    dirname::D
    subject::String

    SubjectPath(d::Union{Nothing,DataPath,StudyPath,DerivativePath}, s::String) = new{typeof(d)}(d, s)
    SubjectPath(d::Union{Nothing,DataPath,StudyPath,DerivativePath}, s) = SubjectPath(d, String(s))
    SubjectPath(s) = SubjectPath(nothing, s)
end

"""
    SessionPath

Represents a path to data `parent` associated with session `label`.
"""
struct SessionPath{D} <: NeuroPath{D}
    dirname::D
    session::String

    SessionPath(d::Union{Nothing,SubjectPath}, s::String) = new{typeof(d)}(d, s)
    SessionPath(d::Union{Nothing,SubjectPath}, s) = SessionPath(d, String(s))
    SessionPath(s) = SessionPath(nothing, s)
end

"""
    ModalityPath

Represents a path to a modality directory `m` for a subject path `p`.
"""
struct ModalityPath{D} <: NeuroPath{D}
    dirname::D
    modality::String

    function ModalityPath(d::Union{Nothing,SubjectPath,SessionPath}, s::String)
        _check_modality_name(s)
        new{typeof(d)}(d, s)
    end
    ModalityPath(d::Union{Nothing,SubjectPath,SessionPath}, s) = ModalityPath(d, String(s))
    ModalityPath(s) = ModalityPath(nothing, s)
end

struct FilePath{D} <: NeuroPath{D}
    dirname::D
    basename::String

    FilePath(d::Union{Nothing,NeuroPath}, s::String) = new{typeof(d)}(d, s)
    FilePath(d::Union{Nothing,NeuroPath}, s) = FilePath(d, String(s))
    FilePath(s) = FilePath(nothing, s)
end

const File = FilePath{Nothing}

const Modality = ModalityPath{Nothing}

const Subject = SubjectPath{Nothing}

const Session = SessionPath{Nothing}

const Data = DataPath{Nothing}

const Study = StudyPath{Nothing}

const Derivative = DerivativePath{Nothing}

############
# Metadata #
############
struct Spreadsheet
    dict::OrderedDict{Symbol,Any}
    data::DataFrame

    Spreadsheet() = new(OrderedDict{Symbol,Any}(), DataFrame())
end

"""
    DataDescription

The file dataset_description.json is a JSON file describing the dataset. Every dataset MUST
include this file with the following fields:
"""
 struct DataDescription
    "`Name`: Name of the dataset (required)"
    Name::String
    "`BIDSVersion::String`: The version of the BIDS standard that was used. (required)"
    BIDSVersion::String
    "`HEDVersion::String`: If HED tags are used, the version of the HED schema used to validate HED tags for study. (recommended)"
    HEDVersion::String
    "`License::String`: What license is this dataset distributed under? (recommended)"
    License::String
    "`Authors::Vector{String}`: List of individuals who contributed to the creation/curation of the dataset (optional)."
    Authors::Vector{String}
    "`Acknowledgements`: Text acknowledging contributions of individuals or institutions beyond those listed in Authors or Funding (optional)."
    Acknowledgements::String
    "`HowToAcknowledge::String`: Instructions how researchers using this dataset should acknowledge the original authors. This field can also be used to define a publication that should be cited in publications that use the dataset (optional)."
    HowToAcknowledge::String
    "`Funding::String`: List of sources of funding (grant numbers) (optional)"
    Funding::String
    "`EthicsApprovals`::Vector{String}`: List of ethics committee approvals of the research protocols and/or protocol identifiers."
    EthicsApprovals::Vector{String}
    "`ReferencesAndLinks::Vector{String}`: List of references to publication that contain information on the dataset, or links (optional)."
    ReferencesAndLinks::Vector{String}
    "`DatasetDOI::String`:The Document Object Identifier of the dataset (not the corresponding paper) (optional)."
    DatasetDOI::String
end

struct StudyMetadata
    README::String
    LICENSE::String
    CHANGES::String
    dataset_description::DataDescription
    participants::Spreadsheet
end

struct SoftwareContainer
    Type::String
    Tag::String
    URI::String

    SoftwareContainer(Type="", Tag="", URI="") = new(Type, Tag, URI)
end

struct SourceInfo
    URL::String
    DOI::String
    Version::String

    SourceInfo(URL="", DOI="", Version="") = new(URL, DOI, Version)
end

struct GeneratedByInfo
    "Name of the pipeline or process that generated the outputs. Use \"Manual\" to indicate the derivatives were generated by hand, or adjusted manually after an initial run of an automated pipeline"
    Name::String
    "Version of the pipeline."
    Version::String
    "Plain-text description of the pipeline or process that generated the outputs. RECOMMENDED if Name is \"Manual\"."
    Description::String
    "URL where the code used to generate the derivatives may be found."
    CodeURL::String
    "Used to specify the location and relevant attributes of software container image used to produce the derivative. Valid keys in this object include Type, Tag and URI with string values."
    Container::SoftwareContainer

    function GeneratedByInfo(Name; Version="",Description="",CodeURL="",Container=SoftwareContainer())
        new(Name, Version, Description, CodeURL, Container)
    end
end

struct DerivedMetadata
    GeneratedBy::Vector{GeneratedByInfo}
    SourceDatasets::Vector{SourceInfo}

    DerivedDescription() = new(Vector{GeneratedByInfo}(), Vector{SourceInfo}())
end

Base.show(io::IO, ::MIME"text/plain", p::NeuroPath) = print(io, _print_path(p))
_print_path(p::Study) = "study($(basename(p)))"
_print_path(p::Session) = "session($(basename(p)))"
_print_path(p::Subject) = "subject($(basename(p)))"
_print_path(p::Modality) = "modality($(basename(p)))"
_print_path(p::Pipeline) = "derivative($(basename(p)))"
_print_path(p::File) = "file($(basename(p)))"
_print_path(p::NeuroPath) = String(p)

