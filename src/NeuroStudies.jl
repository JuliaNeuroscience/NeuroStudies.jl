module NeuroStudies

using DataFrames
using JSON3
using Metadata
using OrderedCollections
using Tables
using Base: @propagate_inbounds

export study, subject, subpaths, session, modality, derived, file


# TODO:
# - https://bids-specification.readthedocs.io/en/stable/99-appendices/10-file-collections.html
# - creating new file with similar entity names
# - Replace DataFrames with `Tables.dictrowtable`

include("entities.jl")
include("types.jl")
include("vectors.jl")
include("paths.jl")
include("utils.jl")

# include("data_type_entities.jl")
# ∘

end
