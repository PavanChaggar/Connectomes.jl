# [Parcellation](@id parcellation)


One of the main components of a Connectome is the Parcellation, which comprises a list of regions over which fibre tracts are summarised. 

```@docs
Parcellation
```

By default we use the Desikan-Killiany-Tourville (DKT) atlas, provided as standard by FreeSurfer. The parcellation is included within the main connectome file that ships with Connectomes.jl. We can load it like so:
```@example getting-started
using JSServe # hide
Page(exportable=true, offline=true) # hide
using WGLMakie # hide

using Connectomes

connectome_path = Connectomes.connectome_path()
```

The parcellation can be loaded from the `connectome_path` in the following way.

```@example getting-started
parc = Parcellation(connectome_path)
```
A parcellation is simply a collection of `Regions`.

```
struct Parcellation
    regions::Vector{Region}
end
```
Where `Regions` comprise pertinent information relating to a given region.
```
struct Region
    ID::Int                 # DKT region ID number
    Label::String           # Region name
    Region::String          # Cortical or Subcortical
    Lobe::String            # Lobe the region belongs to
    Hemisphere::String      # Hemisphere the region belongs to
    x::Float64              # x coordinate 
    y::Float64              # y coordinate
    z::Float64              # z coordinate
end
```

`parc` can be numerically indexed to retrieve regions, either as a `Int`
```@example getting-started
parc[1]

```
or a `Vector{Int}`, which will return a new `Parcellation`.
```@example getting-started
parc[[1, 2, 3]]
```

If we load a `Makie` backend, we can conveniently plot the parcellation. Let's say, we 
just want to plot the left side of the connectome. We can do the following.

```@example getting-started
using WGLMakie
Makie.inline!(true) # hide

left_parc = filter(x -> get_hemisphere(x) == "left", parc)

plot_parc(left_parc; size=(500, 350), view=:left)
```

# API

```@docs
Region
get_node_id
get_label
get_cortex 
get_lobe
get_hemisphere
get_coords
Base.getindex
Base.length
```