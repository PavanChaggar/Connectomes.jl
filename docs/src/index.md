# Connectomes.jl

This is the documentation for Connectomes.jl, a package made for working with human brain connectomes, simulating dynamical systems on networks and visualising brain related images.

## Working with Connectomes 

A Connectome is a spatially embedded graph ``G = (V, E)``. The collection of vertices, ``V``,
are labelled nodes corresponding to discrete brain regions given by a particular brain 
parcellation, and the edge set, ``E``, denotes edges between these vertices, as inferred
from tractography.

Connectomes.jl comes with a connectome and parcellation. The file path can be found 
with the function: 

```@example getting-started
using JSServe # hide
Page(exportable=true, offline=true) # hide
using WGLMakie # hide

using Connectomes

connectome_path = Connectomes.connectome_path()
```

From this path, two datatypes can be loaded: a `Parcellation` or a `Connectome`. A 
parcellation underlies a connectome, so let's start with that. By default, we use 
the Desikan-Killiany-Tourville (DKT) atlas. A parcellation is simply a
collection of `Regions`.

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
The parcellation can be loaded from the `connectome_path` in the following way.

```@example getting-started
parc = Parcellation(connectome_path)
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

left_parc = filter(x -> get_lobe(x) == "subcortex", parc)

plot_parc(left_parc; resolution=(500, 350), view=:front)
```