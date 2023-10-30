function plot_cortex end
function plot_cortex! end
function plot_mesh end
function plot_roi end
function plot_roi! end
function plot_parc end
function plot_parc! end
function plot_vertices end
function plot_vertex! end
function plot_connectome end
function plot_connectome! end
function set_fig end

const meshpath = artifact"DKTMeshes"
mni_cortex() = joinpath(meshpath, "meshes/cortex/connectome-cortex.obj")
fs_cortex() =  joinpath(meshpath, "meshes/cortex/fs-cortex.obj")
rh_cortex() =  joinpath(meshpath, "meshes/cortex/rh-cortex.obj")
lh_cortex() =  joinpath(meshpath, "meshes/cortex/lh-cortex.obj")

RegionDict = Dict(zip([:left, :right, :all, :connectome], [lh_cortex(), rh_cortex(), fs_cortex(), mni_cortex()]))

View = Dict(zip([:right, :front, :left, :back], [0.0, 0.5, 1.0, 1.5]))
