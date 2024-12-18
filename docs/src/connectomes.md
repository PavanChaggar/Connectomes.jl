# [Connectome](@id connectome)


```@docs
Connectome
```

# Plotting Example

Firstly, you will need to load Connectomes and a plotting backend from the [Makie](https://docs.makie.org/stable/). Connectomes.jl uses the Makie.jl backend to organise and render plots.

There are several plotting methods available in Connectomes.jl. In keeping with the Julia custom, plotting methods ending with a `!` add to an existing plot. Whereas those without `!` create a Makie `Scene`.

```@example plot
using JSServe # hide
Page(exportable=true, offline=true) # hide
```

```@example plot
using WGLMakie
Makie.inline!(true) # hide
using Connectomes

plot_cortex(size=(500, 400))
```