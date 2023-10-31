using GLMakie
using CUDA

N = 100
v = CuArray(rand(N, N, N))
vo = Observable(v)
fig, = plot(vo)
display(fig)

for _ in 1:100
    vo[] .= CUDA.rand(size(v)...) # update the plot
    notify(vo)
    sleep(0.1)
end