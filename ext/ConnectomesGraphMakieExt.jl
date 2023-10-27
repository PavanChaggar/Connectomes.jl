module ConnectomesGraphMakieExt

using Artifacts
using Makie, GraphMakie, Connectomes
using ColorSchemes, Colors
using LinearAlgebra
using Graphs

const meshpath = artifact"DKTMeshes"
mni_cortex() = joinpath(meshpath, "meshes/cortex/connectome-cortex.obj")
fs_cortex() =  joinpath(meshpath, "meshes/cortex/fs-cortex.obj")
rh_cortex() =  joinpath(meshpath, "meshes/cortex/rh-cortex.obj")
lh_cortex() =  joinpath(meshpath, "meshes/cortex/lh-cortex.obj")

function set_fig(;resolution::Tuple{Int64, Int64}=(1600,900), view=:front)
    f = Figure(resolution = resolution)
    ax = Axis3(f[1,1], aspect = :data, azimuth = View[view]pi, elevation=0.0pi)
    hidedecorations!(ax)
    hidespines!(ax)
    f
end

RegionDict = Dict(zip([:left, :right, :all, :connectome], [lh_cortex(), rh_cortex(), fs_cortex(), mni_cortex()]))

View = Dict(zip([:right, :front, :left, :back], [0.0, 0.5, 1.0, 1.5]))

function Connectomes.plot_connectome(connectome::Connectome; 
                                    edge_weighted=true, 
                                    edge_alpha=false,
                                    edge_map = ColorSchemes.viridis,
                                    min_edge_size = 0.0,
                                    max_edge_size = 10.0,
                                    node_weighted = true,
                                    node_color= (:blue, 0.5),
                                    node_size = 10.0)
    f = set_fig()
    plot_cortex!(:connectome)
    plot_connectome!(connectome; 
                    edge_weighted=edge_weighted, 
                    edge_map=edge_map, 
                    edge_alpha=edge_alpha,
                    min_edge_size = min_edge_size,
                    max_edge_size = max_edge_size,
                    node_weighted=node_weighted,
                    node_color=node_color,
                    node_size=node_size)
    f
end


function Connectomes.plot_connectome!(connectome::Connectome; 
                                        edge_weighted=true,
                                        edge_alpha=false, 
                                        edge_map = ColorSchemes.viridis,
                                        min_edge_size = 0.0,
                                        max_edge_size = 10.0,
                                        node_weighted = true,
                                        node_color = (:blue, 0.5),
                                        node_size = 10.0)

    g = connectome.graph
    coords = get_coords(connectome.parc)
    positions = Point.(zip(coords[:,1], coords[:,2], coords[:,3]))

    if edge_weighted
        ew = get_edge_weight(connectome)
    if edge_alpha
        edge_color = Colors.alphacolor.(get(edge_map, ew), clamp.(ew, 0.2,1.0))
    else
        edge_color = get(edge_map, ew)
    end
        edge_width = clamp.(max_edge_size .* get_edge_weight(connectome), 
        min_edge_size, max_edge_size)
    else
        edge_color = [colorant"grey" for i in 1:ne(g)]
        edge_width = fill(max_edge_size, ne(g))
    end

    if node_weighted
        node_width = node_size .* Array(diag(degree_matrix(connectome)))
    else    
        node_width = fill(node_size, nv(g))
    end

    graphplot!(g,
                edge_width = edge_width,
                edge_color = edge_color,
                node_size = node_width,
                node_color = fill(node_color, nv(g));
                layout = _ -> positions)
end

end