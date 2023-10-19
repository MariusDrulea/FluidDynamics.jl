using GLMakie
# using FluidDynamics

N = 100
v = zeros(N, N, N, 1, 1)
v[N÷2, N÷2, N÷2, 1, 1] = 10000

v2 = v[:, :, :, 1, 1]
vo = Observable(v2)
fig, = plot(vo)
display(fig)

volume = v
volume_tmp = similar(volume)
volumes = (volume, volume_tmp)
cnt = 1
while cnt <= 10000
    # v_ = diffusion_step(volumes[1+(cnt+1)%2], volumes[1+cnt%2])
    v_ = rand(size(v))
    cnt+=1

    # update the plot
    vo[] .= v_[:, :, :, 1, 1] 
    notify(vo)
    sleep(0.1)
    # sleep(1)
end


# f = (a, b) -> b.pos * b.density - a.pos * a.density 
# arrow(a) -> sum_over_b(a)
