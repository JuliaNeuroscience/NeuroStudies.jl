
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

function _entity_name(s::String)
    if s === "acq"
        return s, true
    elseif s === "label"
        return s, true
    elseif s === "space"
        return s, true
    elseif s === "flip"
        return s, true
    elseif s === "rec"
        return s, true
    elseif s === "sub"
        return s, true
    elseif s === "sample"
        return s, true
    elseif s === "proc"
        return s, true
    elseif s === "part"
        return s, true
    elseif s === "split"
        return s, true
    elseif s === "desc"
        return s, true
    elseif s === "trc"
        return s, true
    elseif s === "recording"
        return s, true
    elseif s === "res"
        return s, true
    elseif s === "dir"
        return s, true
    elseif s === "ses"
        return s, true
    elseif s === "task"
        return s, true
    elseif s === "mt"
        return s, true
    elseif s === "run"
        return s, true
    elseif s === "mod"
        return s, true
    elseif s === "den"
        return s, true
    elseif s === "inv"
        return s, true
    elseif s === "ce"
        return s, true
    elseif s === "echo"
        return s, true
    else
        return s, false
    end
end


## load
function load(f, ::Type{String}, error_on_missing::Bool=false)
    if isfile(f)
        return read(f, String)
    elseif error_on_missing
        error("$f is not a file")
    else
        return ""
    end
end
function load(f, ::Type{OrderedDict{Symbol,Any}}, error_on_missing::Bool=false)
    if isfile(f)
        return OrderedDict{Symbol,Any}(JSON3.read(read(f, String)))
    elseif error_on_missing
        error("$f is not a file")
    else
        return OrderedDict{Symbol,Any}()
    end
end
function load(f, ::Type{DataFrame}, error_on_missing::Bool=false)
     if isfile(f)
        return DataFrame(CSV.File(f, delim="\t"))
    elseif error_on_missing
        error("$f is not a file")
    else
        return DataFrame()
    end
end
function load(p, ::Type{StudyMetadata})
    StudyMetadata(
        load(joinpath(p, "README"), String),
        load(joinpath(p, "LICENSE"), String),
        load(joinpath(p, "CHANGES"), String),
        load(joinpath(p, "dataset_description.json"), DataDescription),
        Spreadsheet(
            load(joinpath(p, "participants.json"), OrderedDict{Symbol,Any}),
            load(joinpath(p, "participants.tsv"), DataFrame)
        )
    )
end
function load(f, ::Type{DataDescription}, error_on_missing::Bool=false)
    if isfile(f)
        d = JSON3.read(read(f, String))
        return DataDescription(
            get(d, :Name, ""),
            get(d, :BIDSVersion, ""),
            get(d, :HEDVersion, ""),
            get(d, :License, ""),
            get(d, :Authors, [""]),
            get(d, :Acknowledgements, ""),
            get(d, :HowToAcknowledge, ""),
            get(d, :Funding, ""),
            get(d, :EthicsApprovals, [""]),
            get(d, :ReferencesAndLinks, [""]),
            get(d, :DatasetDOI, "")
        )
    elseif error_on_missing
        error("$f is not a file")
    else
        return DataDescription()
    end
end

## save
function save(f, data::DataDescription)
    open(f, "w") do io
        JSON3.pretty(io, OrderedDict{Symbol,Any}(
            :Name => data.Name,
            :BIDSVersion => data.BIDSVersion,
            :HEDVersion => data.HEDVersion.
            :License => data.License,
            :Authors => data.Authors,
            :Acknowledgements => data.Acknowledgements,
            :HowToAcknowledge => data.HowToAcknowledge,
            :Funding => data.Funding,
            :EthicsApprovals => data.EthicsApprovals,
            :ReferencesAndLinks => data.ReferencesAndLinks,
            :DatasetDOI => data.DatasetDOI
        ))
    end
end
save(f, d::AbstractString) = write(f, d)
save(f, df::DataFrame) = CSV.write(df, delim="\t")
function save(f, d::OrderedDict{Symbol,Any})
    open(sf * ".json", "w") do io
        JSON3.pretty(io, d)
    end
end
function save(p, d::StudyMetadata)
    save(joinpath(p, "README"), d.README),
    save(joinpath(p, "LICENSE"), d.LICENSE),
    save(joinpath(p, "CHANGES"), d.CHANGES),
    save(joinpath(p, "dataset_description.json"), d.dataset_description),
    save(joinpath(p, "participants.json"), d.participants.dict)
    save(joinpath(p, "participants.tsv"), d.participants.data)
end

## metadata
Metadata.metadata(p::StudyPath) = load(String(p), StudyMetadata)
function Metadata.metadata(p::SubjectPath)
    b = basename(dirname(p)) * "_scans"
    rp = repath(p)
    return Spreadsheet(
        load(joinpath(rp, b * ".json"), OrderedDict{Symbol,Any}),
        load(joinpath(rp, b * ".tsv"), DataFrame)
    )
end
function Metadata.metadata(p::SessionPath)
    b = String(basename(dirname(p))) * "_" * String(basename(p)) * "_scans"
    rp = repath(p)
    return Spreadsheet(
        load(joinpath(rp, b * ".json"), OrderedDict{Symbol,Any}),
        load(joinpath(rp, b * ".tsv"), DataFrame)
    )
end

function Metadata.metadata(p::FilePath)
    load(joinpath(repath(dirname(p)), splitext(basename(p))[1] * ".json"), OrderedDict{Symbol,Any})
end

