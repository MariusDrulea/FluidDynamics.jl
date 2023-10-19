using FluidDynamics
using FluidDynamics: Diffusion

H, W, D = 8, 8, 8
volume = [randCell() for _ in 1:H, _ in 1:W, _ in 1:D]



