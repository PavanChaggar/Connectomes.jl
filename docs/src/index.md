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
using Connectomes

Connectomes.connectome_path()
```