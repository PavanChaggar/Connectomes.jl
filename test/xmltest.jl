@testset "xml" begin
    test = Connectome(Connectomes.connectome_path())

    save_connectome(joinpath(@__DIR__, "test.xml"), test)

    retest = Connectome(joinpath(@__DIR__, "test.xml"))

    for fn in fieldnames(Connectome)
        eval( quote display( @test $test.$fn == $retest.$fn) end)
    end

    rm(joinpath(@__DIR__, "test.xml"))
end