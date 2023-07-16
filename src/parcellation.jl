struct Region
    ID::Int
    Name::String
    roi::String
    Lobe::String
    Hemisphere::String
    x::Float64
    y::Float64
    z::Float64
end

struct Parcellation
    regions::Vector{Region}
end

function Parcellation(ids, labels, regions, lobes, hemispheres, xs, ys, zs)
    Parcellation([Connectomes.Region(ids[i], labels[i], regions[i], lobes[i], hemispheres[i], xs[i], ys[i], zs[i])
     for i in eachindex(ids)])
end

function Base.length(parc::Parcellation)
    length(parc.regions)
end

function Base.show(io::IO, parc::Parcellation)
    print(io, "Parcellation with $(length(parc)) regions")
end

function Base.show(io::IO, roi::Region)
    print(io, "Region $(roi.ID): $(roi.Hemisphere) $(roi.Name)")
end

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
