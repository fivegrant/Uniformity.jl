module Uniformity

import TOML

include("./base.jl")
include("./customization.jl")

export available, unavailable, gander, Option, option, choose, view, @unimplemented

end # module Uniformity
