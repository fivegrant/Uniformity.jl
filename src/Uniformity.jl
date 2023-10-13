module Uniformity

import TOML

include("./customization.jl")

export views, gander, option, choose, view
export Source, Option, View

abstract type Source end

###### OPTIONS ######

@kwdef mutable struct Option{T} 
    default::Union{T,Missing}=missing
    choice::Union{T,Missing}=missing
    description::String=""
end

function Base.string(option::Option)
    str = "|$(if !ismissing(option.choice) option.choice end)|"
    if !ismissing(option.default)
        str += "(default: $(option.default))"
    end
    str
end

struct OptionNotSet <: Exception end
Base.showerror(io, ::OptionNotSet) = print(io, "Option without default was not set")

function option(name::String, selection, description="")
    option(Symbol(name), selection, description)
end

function option(name::Symbol, type::Type, description="")
    name => Option{type}(missing, missing, description)
end

function option(name::Symbol, default, description="")
    name => Option(default, missing, description)
end

function choose(option::Option)
    if !ismissing(option.choice)
        option.choice
    elseif !ismissing(option.default)
        option.default
    else
        throw(OptionNotSet())
    end
end


###### VIEWS ######

@kwdef struct View{S<:Source, T<:Any}
    title::String
    description::String = ""
    options::Dict{Symbol, Option} = Dict()
    tags::Array{String}=[]
    source::Ref{S}
end

"""
    views(source::Source)::AbstractArray{View}   

List available views that the source provides
"""
function views end


gander(view::View) = gander(view.source[], view) 


### VIEW ERRORS ###

@enum UnavailableReason UNIMPLEMENTED UNPERMITTED INVALID

function Base.string(reason::UnavailableReason)
    if reason == UNIMPLEMENTED
        "View is not implemented"
    elseif reason == UNPERMITTED
        "Source does not have proper permission"
    else 
        "View is not valid for the source"
    end
end

@kwdef struct UnavailableException <: Exception
    reason::UnavailableReason = UNIMPLEMENTED
end
Base.showerror(io, e::UnavailableException) = print(io, e.reason)

end # module Uniformity
