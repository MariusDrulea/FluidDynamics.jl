# module Diffusion
    using StaticArrays

    struct Cell
        density::Float64
        velocity::SVector{3, Float64}
    end

    H, W, D = 8, 8, 8

    Matrix3 = Array{Cell, 3} # this is a typedef
    
    randCell() = Cell(rand(), SA[rand(), rand(), rand()])
    randCell()

    volume = [randCell() for _ in 1:H, _ in 1:W, _ in 1:D]

    function diffusion_step(volume_in::Matrix3, volume_out::Matrix3)::Matrix3        
       kernel = ones(3, 3, 3) # TODO: use gaussians
    #    TODO: keep same amount of water - problems in boundaries!
    #    conv3(volume, kernel)
        return volume_out
    end

    function diffusion!(volume, max_steps)::Matrix3
        volume_tmp = similar(volume)
        volumes = (volume, volume_tmp)
        
        cnt = 1
        while cnt <= max_steps
            diffusion_step(volumes[cnt%2], volumes[(cnt+1)%2])
            cnt+=1
        end
        
        cnt%2 == 0 && (volume .= volume_tmp)
        
        return volume
    end

    @time diffusion(volume, 10);
# end