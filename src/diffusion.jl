module Diffusion
    struct Cell
        density::Float64
    end

    H, W, D = 8, 8, 8

    zeros(8, 8, 8)
    Matrix3 = Array{Cell, 3} # this is a typedef
    
    function diffusion!(volume::Matrix3)::Matrix3
        
    end

    function diffusion(volume::Matrix3)::Matrix3
        volume2 = similar(volume)
        return diffusion!(volume2)
    end

    
end