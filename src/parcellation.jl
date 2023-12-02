"""
    Struct
        ID::Int
        Label::String
        Cortex::String
        Lobe::String
        Hemisphere::String
        x::Float64
        y::Float64
        z::Float64
    end
"""
struct Region
    ID::Int
    Label::String
    Cortex::String
    Lobe::String
    Hemisphere::String
    x::Float64
    y::Float64
    z::Float64
end

"""
    Parcellation(path::String)

A `Parcellation` type containing information about the underlying parcellation used in a `Connectome`. 
It is simply a collection of `Region` types. 
```julia
struct Parcellation
    regions::Vector{Region}
end
```
# Example 

```julia
julia> parc = Parcellation(Connectomes.connectome_path())
Parcellation with 83 regions
```
"""
struct Parcellation
    regions::Vector{Region}
end

function Parcellation(ids, labels, cortex, lobes, hemispheres, xs, ys, zs)
    Parcellation([Connectomes.Region(ids[i], labels[i], cortex[i], lobes[i], hemispheres[i], xs[i], ys[i], zs[i])
     for i in eachindex(ids)])
end

function Parcellation(path::String)
    Parcellation(load_parcellation(path)...)
end

"""
    get_node_id(roi::Region)

Return the `ID` of a `Region`. 

# Example 

```julia
julia>get_node_id(parc[1])
1
```
"""
get_node_id(roi::Region) = roi.ID

"""
    get_label(roi::Region)

Return the `Label` of a `Region`. 

# Example 

```julia
julia>get_label(parc[1])
"lateralorbitofrontal"
```
"""
get_label(roi::Region) = roi.Label

"""
    get_cortex(roi::Region)

Return the `Cortex` of a `Region`. 

# Example 

```julia
julia>get_label(parc[1])
""cortical""
```
"""
get_cortex(roi::Region) = roi.Cortex


"""
    get_lobe(roi::Region)

Return the `Lobe` of a `Region`. 

# Example 

```julia
julia>get_lobe(parc[1])
""frontal""
```
"""
get_lobe(roi::Region) = roi.Lobe


"""
    get_hemisphere(roi::Region)

Return the `Hemisphere` of a `Region`. 

# Example 

```julia
julia>get_hemisphere(parc[1])
""right""
```
"""
get_hemisphere(roi::Region) = roi.Hemisphere


"""
    get_coords(roi::Region)
    get_coords(parc::Parcellation)

Return a `Vector{Float64}` of ``(x, y, z)`` coordinates of a `Region`.

# Example 

```julia
>get_coords(parc[1])
3-element Vector{Float64}:
  25.00574653668548
  33.4624935864546
 -16.65079527963058
```

Return a `Matrix{Float64}` of coordinates for all `Regions` in the `Parcellation`.

# Example

```
>get_coords(parc)
83×3 Matrix{Float64}:
 25.0057  33.4625  -16.6508
  ⋮   
```
"""
get_coords(roi::Region) = [roi.x, roi.y, roi.z]

function get_coords(parc::Parcellation)
    Array(transpose(reduce(hcat, get_coords.(parc))))
end

"""
    Base.length(parc::Parcellation)

Return the number of regions in the `Parcellation`

# Example 

```julia
julia> length(parc)
83
```
"""
function Base.length(parc::Parcellation)
    length(parc.regions)
end

function Base.show(io::IO, parc::Parcellation)
    print(io, "Parcellation with $(length(parc)) regions")
end

function Base.show(io::IO, roi::Region)
    print(io, "Region $(roi.ID): $(roi.Hemisphere) $(roi.Label)")
end

"""
    Base.getindex(parc::Parcellation, idx::Int)
    Base.getindex(parc::Parcellation, idx::Vector{Int})

Index the `Parcellation` by `idx::Int`` and return the corresponding `Region`

# Example 

```julia
julia> parc[1]
Region 1: right lateralorbitofrontal
```

Slice the `Parcellation` by into subregions given by the idxs.

# Example 

```julia
julia> parc[[1, 2, 3]]
Parcellation with 3 regions
```
"""
function Base.getindex(parc::Parcellation, idx::Int)
    return parc.regions[idx]
end

function Base.getindex(parc::Parcellation, idx::Vector{Int})
    return Parcellation(parc.regions[idx])
end

function Base.iterate(parc::Parcellation, state=1)
    state > length(parc) ? nothing : (parc[state], state+1)
end

Base.eltype(parc::Parcellation) = Region
Base.IteratorEltype(parc::Parcellation) = Base.HasEltype()
Base.keys(parc::Parcellation) = LinearIndices(1:length(parc))
Base.values(parc::Parcellation) = parc.regions

function Base.filter(func, parc::Parcellation)
    Parcellation(Iterators.filter(func, parc) |> collect)
end

# # Tables interface
Tables.istable(::Type{<:Parcellation}) = true
Tables.rows(p::Parcellation) = p.regions