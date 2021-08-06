function _anat_entities(suffix, src::Entities)
    if suffix == "T1w" || suffix == "T2w" || suffix == "PDw" || suffix == "T2starw" || suffix == "FLAIR" || suffix == "inplaneT1" || suffix == "inplaneT2" || suffix == "PDT2" || suffix == "angio" || suffix == "T2star" || suffix == "FLASH" || suffix == "PD"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, part))
    elseif suffix == "T1map" || suffix == "T2map" || suffix == "T2starmap" || suffix == "R1map" || suffix == "R2map" || suffix == "R2starmap" || suffix == "PDmap" || suffix == "MTRmap" || suffix == "MTsat" || suffix == "UNIT1" || suffix == "T1rho" || suffix == "MWFmap" || suffix == "MTVmap" || suffix == "PDT2map" || suffix == "Chimap" || suffix == "S0map" || suffix == "M0map"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction))
    elseif suffix == "defacemask"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, modality))
    elseif suffix == "MESE" || suffix == "MEGRE"
        return Entities(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, part))
    elseif suffix == "VFA"
        return Entities(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, flip), src, part))
    elseif suffix == "IRT1"
        return Entities(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, inversion), src, part))
    elseif suffix == "MP2RAGE"
        return Entities(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, inversion), src, part))
    elseif suffix == "MPM" || suffix == "MTS"
        return Entities(_get_opt(_get_req(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, mtransfer), src, part))
    elseif suffix == "MTR"
        return Entities(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, mtransfer), src, part))
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _eeg_entities(suffix, src::Entities)
    if suffix == "eeg"
        return Entities(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run))
    elseif suffix == "channels"
        return Entities(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run))
    elseif suffix == "coordsystem"
        return Entities(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, space))
    elseif suffix == "electrodes"
        return Entities(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, space))
    elseif suffix == "events"
        return Entities(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run))
    elseif suffix == "photo"
        return Entities(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition))
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _perf_entities(suffix, src::Entities)
    if suffix == "asl" || suffix == "m0scan"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, reconstruction), src, direction), src, run))
    elseif suffix == "aslcontext"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, reconstruction), src, direction), src, run))
    elseif suffix == "asllabeling"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, reconstruction), src, run))
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _pet_entities(suffix, src::Entities)
    if suffix == "pet"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, task), src, tracer), src, reconstruction), src, run))
    elseif suffix == "blood"
        return Entities(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, task), src, tracer), src, reconstruction), src, run), src, recording))
    elseif suffix == "events"
        return Entities(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, tracer), src, reconstruction), src, run))
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _dwi_entities(suffix, src::Entities)
    if suffix == "dwi"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, direction), src, run), src, part))
    elseif suffix == "sbref"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, direction), src, run), src, part))
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _beh_entities(suffix, src::Entities)
    if suffix == "stim" || suffix == "physio"
        return Entities(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), src, recording))
    elseif suffix == "events" || suffix == "beh"
        return Entities(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run))
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _meg_entities(suffix, src::Entities)
    if suffix == "meg"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), src, processing), src, split))
    elseif suffix == "headshape"
        return Entities(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition))
    elseif suffix == "markers"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, space))
    elseif suffix == "coordsystem"
        return Entities(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition))
    elseif suffix == "channels"
        return Entities(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run), src, processing))
    elseif suffix == "events"
        return Entities(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run))
    elseif suffix == "photo"
        return Entities(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition))
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _fmap_entities(suffix, src::Entities)
    if suffix == "phasediff" || suffix == "phase1" || suffix == "phase2" || suffix == "magnitude1" || suffix == "magnitude2" || suffix == "magnitude" || suffix == "fieldmap"
        return Entities(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, run))
    elseif suffix == "epi" || suffix == "m0scan"
        return Entities(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, ceagent), src, direction), src, run))
    elseif suffix == "TB1DAM"
        return Entities(_get_opt(_get_opt(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, flip), src, inversion), src, part))
    elseif suffix == "TB1EPI"
        return Entities(_get_opt(_get_opt(_get_req(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, inversion), src, part))
    elseif suffix == "TB1AFI" || suffix == "TB1TFL" || suffix == "TB1RFM" || suffix == "RB1COR"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, inversion), src, part))
    elseif suffix == "TB1SRGE"
        return Entities(_get_opt(_get_req(_get_req(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction), src, echo), src, flip), src, inversion), src, part))
    elseif suffix == "TB1map" || suffix == "RB1map"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, run), src, acquisition), src, ceagent), src, reconstruction))
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _func_entities(suffix, src::Entities)
    if suffix == "bold" || suffix == "cbv" || suffix == "sbref"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, ceagent), src, reconstruction), src, direction), src, run), src, echo), src, part))
    elseif suffix == "phase"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, ceagent), src, reconstruction), src, direction), src, run), src, echo))
    elseif suffix == "events"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, ceagent), src, reconstruction), src, direction), src, run))
    elseif suffix == "physio" || suffix == "stim"
        return Entities(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, ceagent), src, reconstruction), src, direction), src, run), src, recording))
    else
        error(suffix * " is not a supported suffix.")
    end
end

function _ieeg_entities(suffix, src::Entities)
    if suffix == "ieeg"
        return Entities(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run))
    elseif suffix == "channels"
        return Entities(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run))
    elseif suffix == "coordsystem"
        return Entities(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, space))
    elseif suffix == "electrodes"
        return Entities(_get_opt(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition), src, space))
    elseif suffix == "events"
        return Entities(_get_opt(_get_opt(_get_req(_get_opt(_get_req((), src, subject), src, session), src, task), src, acquisition), src, run))
    elseif suffix == "photo"
        return Entities(_get_opt(_get_opt(_get_req((), src, subject), src, session), src, acquisition))
    else
        error(suffix * " is not a supported suffix.")
    end
end

