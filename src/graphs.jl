const assetpath = pkgdir(Connectomes, "assets")
Connectome2FS() = deserialize(joinpath(assetpath, "dicts/Connectome2FS.jls"))
FS2Connectome() = deserialize(joinpath(assetpath, "dicts/FS2Connectome.jls"))
node2FS() = deserialize(joinpath(assetpath, "dicts/node2FS.jls"))

connectome_path() = joinpath(assetpath, "connectomes/Connectomes-hcp-scale1.xml")
"""
    Connectome(path::String; norm=true)

Main type introduced by Connectomes.jl,

```julia
struct Connectome
        parc::Parcellation
        graph::SimpleWeightedGraph{Int64, Float64}
        n_matrix::Matrix{Float64}
        l_matrix::Matrix{Float64}
        weight_function::Function
end
```
where `parc` is a `Parcellation`, `graph` is a 
`SimpleWeightedGraph` encoding a weighted Connectome, `n_matrix` is 
the length matrix and `l_matrix` is the length matrix and 
`weight_function` defines the weighting of (n, l) that is used 
to construct the graph. 

# Example

```julia
julia> filter(Connectome(Connectomes.connectomepath()), 1e-2)
Parcellation: 
83×8 DataFrame
 Row │ ID     Label                 Region       Hemisphere  x          y           z            Lobe      
     │ Int64  String                String       String      Float64    Float64     Float64      String    
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │     1  lateralorbitofrontal  cortical     right        25.0057    33.4625    -16.6508     frontal
   2 │     2  parsorbitalis         cortical     right        43.7891    41.4659    -11.8451     frontal
   3 │     3  frontalpole           cortical     right         9.59579   67.3442     -8.94211    frontal
   4 │     4  medialorbitofrontal   cortical     right         5.799     40.7383    -15.7166     frontal
   5 │     5  parstriangularis      cortical     right        48.3993    31.8555      5.60427    frontal
  ⋮  │   ⋮             ⋮                 ⋮           ⋮           ⋮          ⋮            ⋮           ⋮
  80 │    80  Left-Accumbens-area   subcortical  left         -8.14103   11.416      -6.32051    subcortex
  81 │    81  Left-Hippocampus      subcortical  left        -25.5001   -22.6622    -13.6924     temporal
  82 │    82  Left-Amygdala         subcortical  left        -22.7183    -5.11994   -18.8364     temporal
  83 │    83  brainstem             subcortical  none         -6.07796  -31.5015    -32.8539     subcortex
                                                                                            74 rows omitted
Adjacency Matrix: 
83×83 SparseArrays.SparseMatrixCSC{Float64, Int64} with 392 stored entries:
⣮⢛⣣⡠⠀⠀⠀⠀⠀⠀⠀⡁⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠉⡺⢺⠒⣒⠄⢀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠂⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠘⠜⠚⣠⣐⡐⠀⠀⣀⡄⠀⠀⠀⠀⠀⠈⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠐⢐⠸⢴⡳⡄⠌⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⡀⠍⠯⡧⡄⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠄⠠⠀⠄⠀⠼⠁⠀⠀⠉⠯⡣⣄⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄
⠀⠀⠀⠀⠀⠀⠀⠀⠤⠄⠀⠝⠏⠅⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠁
⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡎⡭⡦⠂⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀
⠀⠀⠈⠠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⠋⡏⡩⡕⠀⠄⠀⠀⠐⠐⠀⠀⠀
⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠉⠡⡦⢥⠁⠀⢰⠶⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠅⠓⢯⣳⣐⠂⠀⠀⢀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⣀⠰⠘⢺⣲⣀⠀⠘⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠂⠐⠀⠘⠃⠀⠀⠀⠘⢪⣲⣔⡂
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠄⠀⠀⠀⠀⠀⠀⠀⠀⠐⠒⠀⠰⠹⠐⠀
```
"""
struct Connectome
    parc::Parcellation
    graph::SimpleWeightedGraph{Int64, Float64}
    n_matrix::Matrix{Float64}
    l_matrix::Matrix{Float64}
    weight_function::Function
end

function Connectome(graph_path::String; norm=true, weight_function::Function = (n, l) -> n)
    parc, n_matrix, l_matrix = load_graphml(graph_path)
    sym_n = symmetrise(n_matrix)
    sym_l = symmetrise(l_matrix)
    weighted_graph = weight_function(sym_n, sym_l)
    A = replace(weighted_graph, NaN=>0)

    #Graph = SimpleWeightedGraph(symmetrise(n_matrix ./ (l_matrix)^2))
    if norm
        Graph = SimpleWeightedGraph(A ./ maximum(A))
    else
        Graph = SimpleWeightedGraph(A)
    end
    return Connectome(parc, Graph, n_matrix, l_matrix, weight_function)
end

function Connectome(parc::Parcellation, c::Connectome)
    Connectome(parc, c.graph, c.n_matrix, c.l_matrix, c.weight_function)
end

function Connectome(A::AbstractMatrix, parc::Parcellation)
    G = SimpleWeightedGraph(A)
    Connectome(parc, G, A, A, (n, l) -> n)
end

function Base.show(io::IO, c::Connectome)
    display(c.parc)
    print(io, "Adjacency Matrix: \n") 
    display(adjacency_matrix(c))
end

# convenience functions for processing graphs
function Base.filter(c::Connectome, cutoff::Float64=1e-2)
    G = SimpleWeightedGraph(filter(adjacency_matrix(c), cutoff))
    Connectome(c.parc, G, c.n_matrix, c.l_matrix, c.weight_function)
end

Base.filter(A::SparseMatrixCSC, cutoff::Float64) = A .* (A .> cutoff)

max_norm(A) = A ./ maximum(A)

function symmetrise(A)
    (A + transpose(A)) / 2
end

adjacency_matrix(c::Connectome) = adjacency_matrix(c.graph)
degree_matrix(c::Connectome) = degree_matrix(c.graph)
laplacian_matrix(c::Connectome) = laplacian_matrix(c.graph)

function get_edge_weight(c::Connectome)
    w = weights(c.graph)
    lt_w = UpperTriangular(w) |> sparse
    lt_w.nzval
end

function slice(c::Connectome, idx::Vector{Int}; norm=true)
    N = c.n_matrix[idx, idx]
    L = c.l_matrix[idx, idx]
    weighted_graph = c.weight_function(N, L)
    A = replace(weighted_graph, NaN => 0)
    if norm
        G = A |> max_norm |> SimpleWeightedGraph
    else
        G = SimpleWeightedGraph(A)
    end
    parc = c.parc[idx]
    Connectome(parc, G, N, L, c.weight_function)
end

slice(c::Connectome, parc::Parcellation; norm=true) = slice(c, get_node_id.(parc); norm=norm)

function reweight(c::Connectome; norm=true, weight_function::Function)
    weighted_graph = weight_function(c.n_matrix, c.l_matrix)
    A = replace(weighted_graph, NaN => 0)
    if norm
        G = A |> max_norm |> SimpleWeightedGraph
    else
        G = SimpleWeightedGraph(A)
    end
    Connectome(c.parc, G, c.n_matrix, c.l_matrix, weight_function)
end