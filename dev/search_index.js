var documenterSearchIndex = {"docs":
[{"location":"connectomes/#Guide-to-Connectomes","page":"Connectomes","title":"Guide to Connectomes","text":"","category":"section"},{"location":"connectomes/","page":"Connectomes","title":"Connectomes","text":"Connectome","category":"page"},{"location":"connectomes/#Connectomes.Connectome","page":"Connectomes","title":"Connectomes.Connectome","text":"Connectome(path::String; norm=true)\n\nMain type introduced by Connectomes.jl,\n\nstruct Connectome\n    parc::DataFrame\n    graph::SimpleWeightedGraph{Int64, Float64}\n    n_matrix::Matrix{Float64}\n    l_matrix::Matrix{Float64}\nend\n\nwhere parc is the parcellation atlas, graph is a  SimpleWeightedGraph encoding a weighted Connectome, n_matrix is  the length matrix and l_matrix is the length matrix.\n\nExample\n\njulia> filter(Connectome(Connectomes.connectomepath()), 1e-2)\nParcellation: \n83×8 DataFrame\n Row │ ID     Label                 Region       Hemisphere  x          y           z            Lobe      \n     │ Int64  String                String       String      Float64    Float64     Float64      String    \n─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────\n   1 │     1  lateralorbitofrontal  cortical     right        25.0057    33.4625    -16.6508     frontal\n   2 │     2  parsorbitalis         cortical     right        43.7891    41.4659    -11.8451     frontal\n   3 │     3  frontalpole           cortical     right         9.59579   67.3442     -8.94211    frontal\n   4 │     4  medialorbitofrontal   cortical     right         5.799     40.7383    -15.7166     frontal\n   5 │     5  parstriangularis      cortical     right        48.3993    31.8555      5.60427    frontal\n  ⋮  │   ⋮             ⋮                 ⋮           ⋮           ⋮          ⋮            ⋮           ⋮\n  80 │    80  Left-Accumbens-area   subcortical  left         -8.14103   11.416      -6.32051    subcortex\n  81 │    81  Left-Hippocampus      subcortical  left        -25.5001   -22.6622    -13.6924     temporal\n  82 │    82  Left-Amygdala         subcortical  left        -22.7183    -5.11994   -18.8364     temporal\n  83 │    83  brainstem             subcortical  none         -6.07796  -31.5015    -32.8539     subcortex\n                                                                                            74 rows omitted\nAdjacency Matrix: \n83×83 SparseArrays.SparseMatrixCSC{Float64, Int64} with 392 stored entries:\n⣮⢛⣣⡠⠀⠀⠀⠀⠀⠀⠀⡁⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠉⡺⢺⠒⣒⠄⢀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠂⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠘⠜⠚⣠⣐⡐⠀⠀⣀⡄⠀⠀⠀⠀⠀⠈⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠐⢐⠸⢴⡳⡄⠌⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⡀⠍⠯⡧⡄⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠄⠠⠀⠄⠀⠼⠁⠀⠀⠉⠯⡣⣄⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄\n⠀⠀⠀⠀⠀⠀⠀⠀⠤⠄⠀⠝⠏⠅⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠁\n⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡎⡭⡦⠂⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀\n⠀⠀⠈⠠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⠋⡏⡩⡕⠀⠄⠀⠀⠐⠐⠀⠀⠀\n⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠉⠡⡦⢥⠁⠀⢰⠶⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠅⠓⢯⣳⣐⠂⠀⠀⢀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⣀⠰⠘⢺⣲⣀⠀⠘⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠂⠐⠀⠘⠃⠀⠀⠀⠘⢪⣲⣔⡂\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠄⠀⠀⠀⠀⠀⠀⠀⠀⠐⠒⠀⠰⠹⠐⠀\n\n\n\n\n\n","category":"type"},{"location":"connectomes/#Plotting-Example","page":"Connectomes","title":"Plotting Example","text":"","category":"section"},{"location":"connectomes/","page":"Connectomes","title":"Connectomes","text":"Firstly, you will need to load Connectomes and a plotting backend from the Makie. Connectomes.jl uses the Makie.jl backend to organise and render plots.","category":"page"},{"location":"connectomes/","page":"Connectomes","title":"Connectomes","text":"There are several plotting methods available in Connectomes.jl. In keeping with the Julia custom, plotting methods ending with a ! add to an existing plot. Whereas those without ! create a Makie Scene.","category":"page"},{"location":"connectomes/","page":"Connectomes","title":"Connectomes","text":"using JSServe\nPage(exportable=true, offline=true)","category":"page"},{"location":"connectomes/","page":"Connectomes","title":"Connectomes","text":"using WGLMakie\nusing Connectomes\n\nplot_cortex()","category":"page"},{"location":"#Connectomes.jl","page":"Home","title":"Connectomes.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This is the documentation for Connectomes.jl, a package made for working with human brain connectomes, simulating dynamical systems on networks and visualising brain related images.","category":"page"},{"location":"#Working-with-Connectomes","page":"Home","title":"Working with Connectomes","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A Connectome is a spatially embedded graph G = (V E). The collection of vertices, V, are labelled nodes corresponding to discrete brain regions given by a particular brain  parcellation, and the edge set, E, denotes edges between these vertices, as inferred from tractography.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Connectomes.jl comes with a connectome and parcellation. The file path can be found  with the function: ","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Connectomes\n\nConnectomes.connectome_path()","category":"page"}]
}
