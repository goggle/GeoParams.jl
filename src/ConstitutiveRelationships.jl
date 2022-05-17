module ConstitutiveRelationships

# This implements constitutitive relationships (typically between stress & strainrate)
#

using Base: Float64
using Parameters, LaTeXStrings, Unitful
using ..Units
using GeoParams: AbstractMaterialParam
using BibTeX
using ..MaterialParameters: MaterialParamsInfo
import Base.show, GeoParams.param_info

abstract type AbstractConstitutiveRelationship{T} <: AbstractMaterialParam end

export  param_info,
        dεII_dτII,      dτII_dεII,
        compute_εII!,   compute_εII,
        compute_τII!,   compute_τII,
        strain_rate_circuit

include("CreepLaw/CreepLaw.jl")              # viscous Creeplaws
include("Elasticity/Elasticity.jl")          # elasticity


# add methods programatically 
for myType in (:LinearViscous, :DiffusionCreep, :DislocationCreep, :ConstantElasticity)

    @eval begin
        compute_εII(a::$(myType), TauII, args) = compute_εII(a, TauII; args...) 
        compute_εII!(ε::AbstractArray{_T,N}, s::$(myType){_T}, TauII::AbstractArray{_T,N}, args) where {_T,N} = compute_εII!(ε, s, TauII; args...)
        
        dεII_dτII(a::$(myType), TauII, args) = dεII_dτII(a, TauII; args...) 
        
        compute_τII(a::$(myType), EpsII, args) = compute_τII(a, EpsII; args...) 
        compute_τII!(τ::AbstractArray{_T,N}, s::$(myType){_T}, EpsII::AbstractArray{_T,N}, args) where {_T,N} = compute_τII!(τ, s, EpsII; args...)
        
        if Symbol($myType) !== :ConstantElasticity
            dτII_dεII(a::$(myType), EpsII, args) = dτII_dεII(a, EpsII; args...)
        end
    end
end


end
