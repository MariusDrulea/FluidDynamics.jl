using FluidDynamics
using GLMakie

H, W, D = 8, 8, 8
volume = [randCell() for _ in 1:H, _ in 1:W, _ in 1:D]
densities = density.(volume)
densities = reshape(densities, (8, 8, 8, 1, 1))

densities_out = diffusion!(densities, 10)

# densities_out = similar(densities)
# densities .= diffusion_step(densities, densities_out)

