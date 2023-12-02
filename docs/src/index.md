# Connectomes.jl

This is the documentation for Connectomes.jl, a package made for working with human brain connectomes, simulating dynamical systems on networks and visualising brain related images.

## Working with Connectomes 

A Connectome is a spatially embedded graph ``G = (V, E)``. The collection of vertices, ``V``,
are labelled nodes corresponding to discrete brain regions given by a particular brain 
parcellation, and the edge set, ``E``, denotes edges between these vertices, as inferred
from tractography.

In this package we implement two types: 
* [Parcellation](@ref parcellation)
* [Connectome](@ref connectome)

See their doc pages for more on how to work with and plot each type.