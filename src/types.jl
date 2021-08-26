
abstract type NeuroPath{D,B} end

struct StudyPath{D} <: NeuroPath{D,String}
    dirname::D
    study::String

    StudyPath(d::Union{Nothing,String}, s::String) = new{typeof(d)}(d, s)
    StudyPath(d, s::AbstractString) = StudyPath(d, String(s))
    StudyPath(s) = StudyPath(nothing, s)
end

struct DataPath{D} <: NeuroPath{D,String}
    dirname::D
    basename::String

    function DataPath(d::Union{Nothing,StudyPath}, s::String)
        _check_data_name(s)
        new{typeof(d)}(d, s)
    end
    DataPath(d::Union{Nothing,StudyPath}, s) = DataPath(d, String(s))
    DataPath(s) = DataPath(nothing, s)
end

struct DerivativePath{D} <: NeuroPath{D,String}
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
struct SubjectPath{D} <: NeuroPath{D,String}
    dirname::D
    subject::String

    SubjectPath(d::Union{Nothing,StudyPath,DerivativePath}, s::String) = new{typeof(d)}(d, s)
    function SubjectPath(d::DataPath, s::String)
        if basename(d) === "derivatives"
            error("subject paths within the derivative directory must be within a pipeline.")
        end
        return new{DataPath}(d, s)
    end
    SubjectPath(d, s) = SubjectPath(d, String(s))
    SubjectPath(s) = SubjectPath(nothing, s)
end

"""
    SessionPath

Represents a path to data `parent` associated with session `label`.
"""
struct SessionPath{D} <: NeuroPath{D,String}
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
struct ModalityPath{D} <: NeuroPath{D,String}
    dirname::D
    modality::String

    function ModalityPath(d::Union{Nothing,SubjectPath,SessionPath}, s::String)
        _check_modality_name(s)
        new{typeof(d)}(d, s)
    end
    ModalityPath(d::Union{Nothing,SubjectPath,SessionPath}, s) = ModalityPath(d, String(s))
    ModalityPath(s) = ModalityPath(nothing, s)
end

struct FilePath{D} <: NeuroPath{D,String}
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
_print_path(p::Derivative) = "derivative($(basename(p)))"
_print_path(p::File) = "file($(basename(p)))"
_print_path(p::NeuroPath) = String(p)

