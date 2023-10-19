module Diffusion

export diffusion!, diffusion_step, Cell, randCell, diffusion_kernel

#      c
#      
# c    c'   c
#      
#      c
#
# sum(c) = constant (cantitatea de lichid nu creste sau scade)
#
# c(t, x) - c(t', x) = sum(flow(c(t, x), c(t, y))
#
# k   : 0.25  0.5  0.25
# c(0): 0     1    2     3
#         ->
# flow(c(0, 0), c(0, 1)) = c(0,0) * k(0) - c(0,1) * k(2)
#
# sum(flow(c(0, 0), c(0, k))) = 
#
# sum(k) == 1
# 
# c(t+1, ...) = c + conv(c(t, ...), k)

# conv
# k
# 0.33 0.33 0.33
#
# data                             t
# 0    0    1    0                 |
# 0    0.33 0.33 0.33              V
# 1/9  2/9  3/9  2/9   1/9      
# 0    0    1    
# 

# conv with adding back padding 
# k
# 0.33 0.33 0.33
#
# data
# 0    0    1    0
# 0    0.33 0.66 x
# 1/9  2/9  6/9  xH, W, D = 8, 8, 8
# 0    0    0    x   

    using StaticArrays
    using NNlib
    using Flux

    struct Cell
        density::Float64
        velocity::SVector{3, Float64}
    end

    Matrix3 = Array{Cell, 3} # this is a typedef
    
    randCell() = Cell(rand(), SA[rand(), rand(), rand()])
    randCell()

    volume = [randCell() for _ in 1:H, _ in 1:W, _ in 1:D]

    function diffusion_kernel()
        k = ones(3, 3, 3)
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
