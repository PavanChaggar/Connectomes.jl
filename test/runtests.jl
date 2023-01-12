using Pkg: Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

using Connectomes
using SparseArrays
using DataFrames
using LinearAlgebra
using FileIO
using LightXML
using CSV
using Test

testdir = dirname(@__FILE__)
include(joinpath(testdir, "graphtest.jl"))
include(joinpath(testdir, "xmltest.jl"))