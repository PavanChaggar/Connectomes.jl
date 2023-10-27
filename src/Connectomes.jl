module Connectomes

using Artifacts
using LightXML
using SparseArrays
using SimpleWeightedGraphs
using Graphs
# using Makie
# using GraphMakie
using CSV
using DelimitedFiles
using FileIO
using LinearAlgebra
# using Colors
# using ColorSchemes
using Serialization
using Tables
import Graphs: degree
import SimpleWeightedGraphs: adjacency_matrix, degree_matrix, laplacian_matrix


include("parcellation.jl")
export Parcellation, Region
export get_node_id, get_label, get_region, get_lobe, get_hemisphere, get_coords

include("graphs.jl")
export Connectome
export graph_filter
export degree
export Connectome2FS
export FS2Connectome
export read_cmtk_parcellation
export cmtkConnectome
export adjacency_matrix
export degree_matrix
export laplacian_matrix
export get_edge_weight
export slice
export reweight

include("graphml.jl")
export save_connectome

include("plotting.jl")
export plot_cortex
export plot_cortex!
export plot_mesh
export plot_roi
export plot_roi!
export plot_parc
export plot_vertices
export plot_vertex!
export plot_connectome
export plot_connectome!

end
