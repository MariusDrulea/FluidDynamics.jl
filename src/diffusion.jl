# module Diffusion

export diffusion!, diffusion_step, Cell, randCell, diffusion_kernel, density

    using StaticArrays
    using NNlib
    import Base:+,*
    

    struct Cell
        density::Float64
        velocity::SVector{3, Float64}

        Cell(density, velocity=SVector{3, Float64}(0, 0, 0)) = new(density, velocity)
    end

    density(c::Cell) = c.density

    Cell(f::Float64) = f
    a::Cell + b::Cell = Cell(a.density + b.density, a.velocity + b.velocity)
    a::Cell * f::Float64 = Cell(a.density * f, a.velocity * f)
    f::Float64 * a::Cell = a * f

    Matrix3 = Array{Cell, 3} # this is a typedef
    
    randCell() = Cell(rand(), SA[rand(), rand(), rand()])
    randCell()

    function diffusion_kernel()
        k = ones(3, 3, 3, 1, 1)
        return k ./ length(k)
    end

    # (W, H, Cin, N) input #TODO: clarify this for NNlib
    # (w, h, Cin, Cout, N)
    function diffusion_step(volume_in, volume_out)
        k = diffusion_kernel() 
        vol_pad = NNlib.pad_repeat(volume_in, (1, 1, 1, 1, 1, 1))   
        volume_out .= conv(vol_pad, k)
        return volume_out
    end

    function diffusion!(volume, max_steps)
        volume_tmp = similar(volume)
        volumes = (volume, volume_tmp)
        
        cnt = 1
        while cnt <= max_steps
            diffusion_step(volumes[1+(cnt+1)%2], volumes[1+cnt%2])
            cnt+=1
        end
        
        cnt%2 == 0 && (volume .= volume_tmp)
        
        return volume
    end

# end
