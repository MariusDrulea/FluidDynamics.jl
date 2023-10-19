module Diffusion

    export diffusion!, diffusion_step, Cell, randCell, diffusion_kernel

    using StaticArrays
    using NNlib
    import Base:+,*
    

    struct Cell
        density::Float64
        velocity::SVector{3, Float64}

        Cell(density, velocity=SVector{3, Float64}(0, 0, 0)) = new(density, velocity)
        
    end

    Cell(f::Float64) = f
    a::Cell + b::Cell = Cell(a.density + b.density, a.velocity + b.velocity)
    a::Cell * f::Float64 = Cell(a.density * f, a.velocity * f)
    f::Float64 * a::Cell = a * f

    Matrix3 = Array{Cell, 3} # this is a typedef
    
    randCell() = Cell(rand(), SA[rand(), rand(), rand()])
    randCell()

    volume = [randCell() for _ in 1:H, _ in 1:W, _ in 1:D]

    function diffusion_kernel()
        k = ones(3, 3, 3, 1)
        return k ./ length(k)
    end

    function diffusion_step(volume_in, volume_out)
        k = diffusion_kernel()        
        volume_out = conv(NNlib.pad_repeat(volume_in, (1, 1, 1, 1, 1, 1)), k)
        return volume_out
    end

    function diffusion!(volume, max_steps)
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

end
