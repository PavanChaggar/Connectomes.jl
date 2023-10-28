module ConnectomesMakieExt

using Artifacts
using Connectomes
import Connectomes: RegionDict, View, meshpath
using Makie
using ColorSchemes
using Colors
using MeshIO, FileIO

function Connectomes.set_fig(;resolution::Tuple{Int64, Int64}=(1600,900), view=:front)
    f = Figure(resolution = resolution)
    ax = Axis3(f[1,1], aspect = :data, azimuth = View[view]pi, elevation=0.0pi)
    hidedecorations!(ax)
    hidespines!(ax)
    f
end

function Connectomes.plot_cortex!(region::Symbol=:all; color=(:grey,0.05), transparency::Bool=true, kwargs...)
    mesh!(load(RegionDict[region]), color=color, transparency=transparency, kwargs...)
end

function Connectomes.plot_cortex(region::Symbol=:all; resolution=(800, 600), view=:left, color=(:grey,1.0), transparency::Bool=false, kwargs...)
    f = set_fig(resolution=resolution, view=view)
    plot_cortex!(region; color, transparency, kwargs...)
    f
end

function Connectomes.plot_parc!(parc::Parcellation)
    colors = distinguishable_colors(length(parc))
    for (i, roi) in enumerate(parc)
        plot_roi!(get_node_id(roi), colors[i])
    end
end

function Connectomes.plot_parc(parc::Parcellation; view=:left)
    f = set_fig(;view=view)
    Connectomes.plot_parc!(parc)
    f
end

function Connectomes.plot_roi!(roi::Int, color=(:grey,1.0); transparency=false)
    roi = joinpath(meshpath, "meshes/DKT/roi_$(roi).obj")
    mesh!(load(roi), color=color, transparency=transparency)
end

function Connectomes.plot_roi!(rois::Vector{Int64}, colors::Vector{Float64}, cmap::ColorSchemes.ColorScheme; transparency=false)
    [plot_roi!(roi, get(cmap, color); transparency=transparency) for (roi, color) in zip(rois, colors)]
end

function Connectomes.plot_roi(rois, colors, cmap; transparency=false, view=:front, resolution=(1600,900))
    f  = set_fig(;resolution=resolution, view=view)
    plot_roi!(rois, colors, cmap; transparency=transparency)
    f
end

function Connectomes.plot_vertex!(connectome::Connectome, node_size=10, color=(:blue, 0.5), transparency::Bool=true)
    x, y, z = connectome.parc.x[:], connectome.parc.y[:], connectome.parc.z[:]
    meshscatter!(x, y, z, markersize=node_size, color=color, transparency=transparency)
end

function Connectomes.plot_vertices(connectome::Connectome; node_size=1.0, color=(:blue,0.5))
    f  = set_fig()
    plot_cortex!(:connectome)
    plot_vertex!(connectome, node_size, color)
    f
end

end