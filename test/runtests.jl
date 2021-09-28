using CoolDicts
using Test

cooldict = (
    empty = CoolDict(),
    one_arg = CoolDict(:a=>5),
    two_arg = CoolDict(:a=>5, :b=>2),
    vector = CoolDict([:a=>5, :b=>2]),
    hetero = CoolDict(:a=>5, :b=>[5, 6]),
    dict = CoolDict(Dict([:a=>5, :b=>2])),
    cooldict = CoolDict(CoolDict(:a=>5)),
    kwargs = CoolDict(a=5, b=2),
    nt = CoolDict((a=5, b=2)),
    empty_explicit = CoolDict{Float64}(),
    one_arg_explicit = CoolDict{Float64}(:a=>5),
    dict_explicit = CoolDict{Float64}(Dict([:a=>5, :b=>2])),
    convert = CoolDict{Float64}(CoolDict(:a=>5, :b=>2)),
    kwargs_explicit = CoolDict{Float64}(a=5, b=2),
    nt_explicit = CoolDict{Float64}((a=5, b=2)),
)

@testset "Constructors" begin
    @test cooldict.empty isa CoolDict{Any}
    @test cooldict.one_arg isa CoolDict{Int}
    @test cooldict.two_arg isa CoolDict{Int}
    @test cooldict.hetero isa CoolDict{Any}
    @test cooldict.kwargs isa CoolDict{Int}
    @test cooldict.nt isa CoolDict{Int}
    @test cooldict.empty_explicit isa CoolDict{Float64}
    @test cooldict.one_arg_explicit isa CoolDict{Float64}
    @test cooldict.dict_explicit isa CoolDict{Float64}
    @test cooldict.convert isa CoolDict{Float64}
    @test cooldict.kwargs_explicit isa CoolDict{Float64}
    @test cooldict.nt_explicit isa CoolDict{Float64}
end

@testset "Interface" begin
    @testset "length" begin
        @test length(cooldict.empty) == 0
        @test length(cooldict.two_arg) == 2
    end

    @testset "iterate" begin
        out_pairs = Any[]
        out_key_val = Any[]

        for pair in cooldict.vector
            push!(out_pairs, pair)
        end
        @test out_pairs[1] == (:a => 5)

        for (key, val) in cooldict.vector
            push!(out_key_val, (key, val))
        end
        @test out_key_val[1] == (:a, 5)
    end

    @testset "{get|set}{index|property}" begin
        cooldict_vector = deepcopy(cooldict.vector)
        cooldict_vector.a = 100
        cooldict_vector[:b] = 200

        @test cooldict.vector[:a] == cooldict.vector.a == 5
        @test cooldict_vector.a == 100
        @test cooldict_vector.b == 200
    end

    @testset "keys, propertynames, values" begin
        @test collect(keys(cooldict.hetero)) == [:a, :b]
        @test propertynames(cooldict.hetero) == (:a, :b)
        @test collect(values(cooldict.hetero)) == [5, [5, 6]]
    end

    @testset "convert" begin
        @testset "Dict" begin
            @test convert(Dict, cooldict.vector) == Dict(:a=>5, :b=>2)
            @test Dict(cooldict.vector) == Dict(:a=>5, :b=>2)
        end

        @testset "NamedTuple" begin
            @test convert(NamedTuple, cooldict.vector) == (a=5, b=2)
            @test NamedTuple(cooldict.vector) == (a=5, b=2)
        end
    end
end