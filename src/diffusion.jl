# module Diffusion

export diffusion!, diffusion_step, Cell, randCell, diffusion_kernel, density

    using StaticArrays
    using NNlib
    import Base

    Velocity = SVector{3, Float64}

    struct Cell
        density::Float64
        velocity::Velocity

        Cell(density, velocity=Velocity(0, 0, 0)) = new(density, velocity)
    end

    struct Volume <: AbstractArray{Cell, 3}
        densities::Array{Float64, 3}
        velocities::Array{Velocity, 3}

        Volume(w, h, d) = new(zeros(Float64, w, h, d), zeros(Velocity, w, h, d))
    end

    function Base.getindex(v::Volume, i...)
        return Cell(v.densities[i...], v.velocities[i...])
    end

    function Base.setindex!(v::Volume, c::Cell, i...)
        v.densities[i...] = c.density
        v.velocities[i...] = c.velocity
    end

    Base.size(v::Volume) = size(v.densities)

    
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
