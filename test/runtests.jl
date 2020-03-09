#!/usr/bin/env julia

using Test, DynamicBounds

@testset "Integrator Attributes Interface" begin

    struct UndefinedIntegrator <: DEqR.AbstractDERelaxIntegator end
    struct UndefinedProblem <: DEqR.AbstractDERelaxProblem end

    mutable struct TestIntegrator <: DEqR.AbstractODERelaxIntegator
        temp::Float64
    end

    DEqR.supports(::TestIntegrator, ::DEqR.IntegratorName) = true
    DEqR.supports(::TestIntegrator, ::DEqR.Gradient) = true
    DEqR.supports(::TestIntegrator, ::DEqR.Subgradient) = true
    DEqR.supports(::TestIntegrator, ::DEqR.Bound) = true
    DEqR.supports(::TestIntegrator, ::DEqR.Relaxation) = true
    DEqR.supports(::TestIntegrator, ::DEqR.IsNumeric) = true
    DEqR.supports(::TestIntegrator, ::DEqR.IsSolutionSet) = true
    DEqR.supports(::TestIntegrator, ::DEqR.TerminationStatus) = true
    DEqR.supports(::TestIntegrator, ::DEqR.Value) = true

    DEqR.get(t::TestIntegrator, a::DEqR.IntegratorName) = "TestIntegrator"
    DEqR.get(t::TestIntegrator, a::DEqR.Gradient) = t.temp
    DEqR.get(t::TestIntegrator, a::DEqR.Subgradient) = t.temp
    DEqR.get(t::TestIntegrator, a::DEqR.Bound) = t.temp
    DEqR.get(t::TestIntegrator, a::DEqR.Relaxation) = t.temp
    DEqR.get(t::TestIntegrator, a::DEqR.IsNumeric) = true
    DEqR.get(t::TestIntegrator, a::DEqR.IsSolutionSet) = true
    DEqR.get(t::TestIntegrator, a::DEqR.TerminationStatus) = t.temp
    DEqR.get(t::TestIntegrator, a::DEqR.Value) = t.temp

    DEqR.set(t::TestIntegrator, a::DEqR.Gradient, value) = (t.temp = value)
    DEqR.set(t::TestIntegrator, a::DEqR.Subgradient, value) = (t.temp = value)
    DEqR.set(t::TestIntegrator, a::DEqR.Bound, value) = (t.temp = value)
    DEqR.set(t::TestIntegrator, a::DEqR.Relaxation, value) = (t.temp = value)
    DEqR.set(t::TestIntegrator, a::DEqR.TerminationStatus, value) = (t.temp = value)
    DEqR.set(t::TestIntegrator, a::DEqR.Value, value) = (t.temp = value)

    undefined_integrator = UndefinedIntegrator()
    @test !DEqR.supports(undefined_integrator, DEqR.IntegratorName())
    @test !DEqR.supports(undefined_integrator, DEqR.Gradient{DEqR.LOWER}(1.0))
    @test !DEqR.supports(undefined_integrator, DEqR.Subgradient{DEqR.LOWER}(1.0))
    @test !DEqR.supports(undefined_integrator, DEqR.Bound{DEqR.LOWER}(1.0))
    @test !DEqR.supports(undefined_integrator, DEqR.Relaxation{DEqR.LOWER}(1.0))
    @test !DEqR.supports(undefined_integrator, DEqR.IsNumeric())
    @test !DEqR.supports(undefined_integrator, DEqR.IsSolutionSet())
    @test !DEqR.supports(undefined_integrator, DEqR.TerminationStatus())
    @test !DEqR.supports(undefined_integrator, DEqR.Value())

    test_integrator = TestIntegrator(1.0)
    @test @inferred DEqR.supports(test_integrator, DEqR.IntegratorName())
    @test @inferred DEqR.supports(test_integrator, DEqR.Gradient{DEqR.LOWER}(1.0))
    @test @inferred DEqR.supports(test_integrator, DEqR.Subgradient{DEqR.LOWER}(1.0))
    @test @inferred DEqR.supports(test_integrator, DEqR.Bound{DEqR.LOWER}(1.0))
    @test @inferred DEqR.supports(test_integrator, DEqR.Relaxation{DEqR.LOWER}(1.0))
    @test @inferred DEqR.supports(test_integrator, DEqR.IsNumeric())
    @test @inferred DEqR.supports(test_integrator, DEqR.IsSolutionSet())
    @test @inferred DEqR.supports(test_integrator, DEqR.TerminationStatus())
    @test @inferred DEqR.supports(test_integrator, DEqR.Value())

    @test_nowarn @inferred DEqR.set(test_integrator, DEqR.Gradient{DEqR.LOWER}(1.1), 1.2)
    val = @inferred DEqR.get(test_integrator, DEqR.Gradient{DEqR.LOWER}(1.1))
    @test val === 1.2
    @test_nowarn @inferred DEqR.set(test_integrator, DEqR.Subgradient{DEqR.LOWER}(1.1), 1.3)
    val = @inferred DEqR.get(test_integrator, DEqR.Subgradient{DEqR.LOWER}(1.1))
    @test val === 1.3
    @test_nowarn @inferred DEqR.set(test_integrator, DEqR.Bound{DEqR.LOWER}(1.1), 1.4)
    val = @inferred DEqR.get(test_integrator, DEqR.Bound{DEqR.LOWER}(1.1))
    @test val === 1.4
    @test_nowarn @inferred DEqR.set(test_integrator, DEqR.Relaxation{DEqR.LOWER}(1.1), 1.5)
    val = @inferred DEqR.get(test_integrator, DEqR.Relaxation{DEqR.LOWER}(1.1))
    @test val === 1.5
    @test_nowarn DEqR.set(test_integrator, DEqR.Value(), 1.53)
    val = @inferred DEqR.get(test_integrator, DEqR.Value())
    @test val === 1.53

    sval = @inferred DEqR.get(test_integrator, DEqR.IntegratorName())
    @test sval === "TestIntegrator"
    @test @inferred DEqR.get(test_integrator, DEqR.IsNumeric())
    @test @inferred DEqR.get(test_integrator, DEqR.IsSolutionSet())

    @test_nowarn @inferred DEqR.set(test_integrator, DEqR.TerminationStatus(), 1.9)
    val = @inferred DEqR.get(test_integrator, DEqR.TerminationStatus())
    @test val === 1.9

    @test_throws ArgumentError DEqR.get(UndefinedIntegrator(), DEqR.IntegratorName())
end

@testset "pODE Problem" begin

    x0(p) = [0.5; 0.4]
    xL(t) = t
    xU(t) = 3*t.^2

    function f(du,u,p,t)
        du[1] = u[1]*p[1]
        du[2] = u[2]*p[2]
        return
    end

    function user_jac(out,u,p,t)
        out[:,:] = [2.0 2.0; 2.0 2.0]
        return
    end

    xeval = [2.0; 3.0]
    p = [0.7; 0.8]
    pL = [0.5; 0.4]
    pU = [1.1; 1.0]
    xLc = [2.0; 3.1]
    xUc = [3.0; 4.1]
    tspan = (0.0,10.0)
    tsupports = [i for i in 0:0.25:10]

    ode_prob1 = @test_nowarn DEqR.ODERelaxProb(f, tspan, x0, pL, pU)
    ode_prob2 = @test_nowarn DEqR.ODERelaxProb(ODEFunction(f), (0.0,10.0), x0, pL, pU, xL = xLc, xU = xUc)
    ode_prob3 = @test_nowarn DEqR.ODERelaxProb(ODEFunction(f), (0.0,10.0), x0, pL, pU, jacobian = user_jac)

    out = zeros(Float64, 2)
    jout = zeros(Float64, 2, 2)
    @test_nowarn @inferred ode_prob1.f(out, xeval, p, 1.5)
    @test out[1] == 1.4
    @test isapprox(out[2],  2.4)

    @test ode_prob2.xL === xLc
    @test ode_prob2.xU === xUc

    @test DEqR.supports(ode_prob3, DEqR.HasStateBounds())
    @test DEqR.supports(ode_prob3, DEqR.HasConstantStateBounds())
    @test DEqR.supports(ode_prob3, DEqR.HasVariableStateBounds())
    @test DEqR.supports(ode_prob3, DEqR.HasUserJacobian())

    flag = @test_nowarn @inferred DEqR.get(ode_prob3, DEqR.HasStateBounds())
    @test !flag
    flag = @test_nowarn @inferred DEqR.get(ode_prob3, DEqR.HasConstantStateBounds())
    @test !flag
    flag = @test_nowarn @inferred DEqR.get(ode_prob3, DEqR.HasVariableStateBounds())
    @test !flag
    @test @inferred DEqR.get(ode_prob3, DEqR.HasUserJacobian())

    @test_throws AssertionError DEqR.ODERelaxProb(ODEFunction(f), (0.0,10.0),
                                                  x0, pL, pU,
                                                  xL = xLc,
                                                  xU = [1.0; 2.0; 3.0])
end

@testset "pODEs Library Utilities" begin
end

@testset "Scott2013" begin
end
