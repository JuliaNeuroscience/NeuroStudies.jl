

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

struct StudyInfo
    readme::String
    license::String
    changes::String
    # TODO participants
    description::DataDescription
end

""" NeuroStudy """
struct NeuroStudy <: AbstractNeuroPath
    abspath::String  
end
Base.abspath(x::NeuroStudy) = getfield(x, :abspath)
Base.isdir(x::NeuroStudy) = isdir(abspath(x))

@inline function Base.getproperty(x::NeuroStudy, s::Symbol)
    if s === :code
        return DataPath(x, code)
    elseif s === :sourcedata
        return DataPath(x, sourcedata)
    elseif s === :stimuli
        return DataPath(x, stimuli)
    elseif s === :derivatives
        return DataPath(x, derivatives)
    elseif s === :rawdata
        return DataPath(x, rawdata)
    elseif s === :subject
        return DataPath(x, home)
    elseif s === :phenotype
        return DataPath(x, phenotype)
    else
        return metadata(x, s)
    end
end


