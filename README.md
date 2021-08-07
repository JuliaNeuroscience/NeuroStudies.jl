# NeuroStudies

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Tokazama.github.io/NeuroStudies.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Tokazama.github.io/NeuroStudies.jl/dev)
[![Build Status](https://github.com/Tokazama/NeuroStudies.jl/workflows/CI/badge.svg)](https://github.com/Tokazama/NeuroStudies.jl/actions)


Package for organizing neuroscience studies. Design is highly motivated by the [Brain Imaging Data Structure (BIDS) specification](https://github.com/bids-standard/bids-specification).

```julia
julia> using NeuroStudies

julia> s = study("MyStudy")
study(MyStudy)

julia> sub = subject("sub-001")
subject(sub-001)

julia> ses = session("ses-1")
session(ses-1)

julia> mod = modality("anat")
modality(anat)

julia> p = joinpath(pwd(), s, sub, ses, mod)
/Users/zchristensen/projects/NeuroStudies.jl/MyStudy/sub-001/ses-1/anat

julia> d = derivative("vbm")
derivative(vbm)

julia> relpath(p, d)
/Users/zchristensen/projects/NeuroStudies.jl/MyStudy/derivatives/vbm/sub-001/ses-1/anat

```



