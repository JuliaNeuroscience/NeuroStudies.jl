using NeuroStudies
using Documenter

DocMeta.setdocmeta!(NeuroStudies, :DocTestSetup, :(using NeuroStudies); recursive=true)

makedocs(;
    modules=[NeuroStudies],
    authors="Zachary P. Christensen <zchristensen7@gmail.com> and contributors",
    repo="https://github.com/Tokazama/NeuroStudies.jl/blob/{commit}{path}#{line}",
    sitename="NeuroStudies.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Tokazama.github.io/NeuroStudies.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Tokazama/NeuroStudies.jl",
)
