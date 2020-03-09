# DiffEqRelax.jl: Validated Bounds and Relaxations of Differential Equations

This package provides
An abstraction layer for constructing valid relaxations
and bounds on the solution sets (and numerical solutions of) parametric ODEs,
and DAEs. Evaluations of the parametric ODES/DAEs are made available by linking
the specific `integrator` to an equivalent evaluation using solvers present in
DifferentialEquations.jl.

## Example Usage

## The DiffEqRelax.jl abstraction layer.

The abstraction layer for DiffEqRelax is divided into three major parts. First, there are problems (`<:`) which hold all the information required to define a well-posed parametric differential equation problem. Second, there are integrators (`<:`) which hold all the information require to compute relaxations of the problem or `integrate` the parametric differential equation problem at a particular parameter value.

## Integrators available

- *Wilhelm2019*: Provides valid bounds and relaxations of the numerical solutions of systems of ODEs via second-order implicit methods.

## Adding new problems/integrators
### Adding new integrators

- Define the new integrator structure and extend make.
  - The integrator should be an abstract subtype of `AbstractODERelaxIntegator` for parametric systems of ODEs.
  - The integrator should be an abstract subtype of `AbstractDAERelaxIntegator` for parametric systems of DAEs.
  - Otherwise, it should be a subtype of abstract subtype of `AbstractDERelaxIntegator` associated with a specific problem form.
- Extend relax!
- Extend integrate!
- Extend support/set/get/get!/getall! for all supported attributes

- Define new problems by adding a structure `<: AbstractDERelaxProblem`
- Add a corresponding structure `<: AbstractRelaxationAttribute` to hold the solution information.
- The extend the support and get functions for all supported attributes

## References

## Related Packages
