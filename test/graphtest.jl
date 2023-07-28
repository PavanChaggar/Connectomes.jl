
@testset "Connectomes.jl" begin
    connectome = Connectome(Connectomes.connectome_path())

    @test connectome isa Connectome
    @test adjacency_matrix(connectome) isa SparseMatrixCSC{Float64, Int64}
    @test degree_matrix(connectome) isa SparseMatrixCSC{Float64, Int64}
    @test laplacian_matrix(connectome) isa SparseMatrixCSC{Float64, Int64}

    c1 = filter(connectome)
    A1 = adjacency_matrix(c1)
    c2 = filter(connectome, 1e-3)
    A2 = adjacency_matrix(c2)
    
    @test c1 isa Connectome
    @test c2 isa Connectome
    @test maximum(A1.nzval) == maximum(A2.nzval)
    @test minimum(A1.nzval) > minimum(A2.nzval)
    @test length(A1.nzval) < length(A2.nzval)

    parc = connectome.parc
    @test parc isa Parcellation
    @test length(parc) == length(get_id.(parc)) == 83
    @test size(get_coords(parc)) == (83, 3)

    cortex = filter(x -> x.Lobe != "subcortex", connectome.parc)
    cortex_c = slice(connectome, cortex)

    @test cortex_c isa Connectome 
    @test size(cortex_c.n_matrix) == (length(cortex), length(cortex))
    A3 = adjacency_matrix(cortex_c)
    @test maximum(A3) == 1.0
    idx = get_id.(cortex)
    @test cortex_c.n_matrix == connectome.n_matrix[idx, idx]
    @test cortex_c.l_matrix == connectome.l_matrix[idx, idx]

    N = connectome.n_matrix
    L = connectome.l_matrix
    diffusive_weights = replace(N ./ L.^2, NaN => 0) |> Connectomes.max_norm

    weighted_connectome = Connectome(Connectomes.connectome_path(); 
                                     weight_function = (n, l) -> n ./ l.^2)

    weighted_connectome_A = adjacency_matrix(weighted_connectome) |> Array

    reweighted_connectome = reweight(connectome; norm=true, weight_function = (n, l) -> n ./ l.^2)
    reweighted_connectome_A = adjacency_matrix(reweighted_connectome) |> Array

    @test diffusive_weights == weighted_connectome_A == reweighted_connectome_A
end
