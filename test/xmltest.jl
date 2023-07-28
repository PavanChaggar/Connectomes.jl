@testset "xml" begin
    test = Connectome(Connectomes.connectome_path())

    save_connectome(joinpath(@__DIR__, "test.xml"), test)

    retest = Connectome(joinpath(@__DIR__, "test.xml"))

    for (test_roi, retest_roi) in zip(test.parc, retest.parc)
        @test test_roi == retest_roi
    end
    
    for fn in (:graph, :n_matrix, :l_matrix)
        println(fn)
        eval( quote display( @test $test.$fn == $retest.$fn) end)
    end

    rm(joinpath(@__DIR__, "test.xml"))
end