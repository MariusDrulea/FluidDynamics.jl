using GLMakie
using FluidDynamics
using NNlib

N = 11
v = zeros(N, N, N, 1, 1)
v[(N+1)÷2, (N+1)÷2, (N+1)÷2, 1, 1] = N^3

# vgpu = CuArray(v)

v2 = v[:, :, :, 1, 1]
vo = Observable(v2)
fig, = plot(vo)
display(fig)

volume = v
volume_tmp = similar(volume)
volumes = (volume, volume_tmp)
cnt = 1
while cnt <= 100
    v_ = diffusion_step(volumes[1+(cnt+1)%2], volumes[1+cnt%2])
    # v_ = rand(size(v))
    cnt+=1

    if cnt % 1 == 0
        # update the plot
        v2_ = v_[:, :, :, 1, 1]
        vo[] .= v2_
        notify(vo)
        sleep(0.1)
        # sleep(1)
    end
    println(cnt)
end


# f = (a, b) -> b.pos * b.density - a.pos * a.density 
# arrow(a) -> sum_over_b(a)
