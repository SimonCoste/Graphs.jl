function _harmonize_type(g::AbstractGraph{T}, c::Vector{S}) where {T,S<:Integer}
    return convert(Vector{T}, c)
end

@testset "Prufer trees" begin
    t1 = Graph(6)
    for e in [(1, 4), (2, 4), (3, 4), (4, 5), (5, 6)]
        add_edge!(t1, e...)
    end
    code = [4, 4, 4, 5]

    t2 = path_graph(2)
    t3 = star_graph(10)
    t4 = binary_tree(3)

    g1 = cycle_graph(8)
    g2 = complete_graph(4)
    g3 = Graph(5)

    d1 = cycle_digraph(5)
    d2 = path_digraph(5)
    d3 = DiGraph(2)
    add_edge!(d3, 1, 2)
    add_edge!(d3, 2, 1)

    @testset "tree_check" begin
        for t in testgraphs(t1, t2, t3)
            @test is_tree(t)
        end
        for g in testgraphs(g1, g2, g3)
            @test !is_tree(g)
        end
        for g in testgraphs(d1, d2, d3)
            @test_throws ArgumentError is_tree(g)
        end
    end

    @testset "encode/decode" begin
        @test prufer_decode(code) == t1
        @test prufer_encode(t1) == code
        for g in testgraphs(t3, t4)
            ret_code = prufer_encode(g)
            @test prufer_decode(ret_code) == g
        end
    end

    @testset "errors" begin
        b1 = [5, 8, 10, 1, 2]
        b2 = Vector{Int}()
        @test_throws ArgumentError prufer_decode(b1)
        @test_throws ArgumentError prufer_decode(b2)

        for g in testgraphs(g1, g2, g3)
            @test_throws ArgumentError prufer_encode(g)
        end

        for g in testgraphs(d1, d2, d3)
            @test_throws MethodError prufer_encode(g)
        end
    end
end
