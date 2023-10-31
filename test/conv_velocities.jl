using FluidDynamics
const fd = FluidDynamics
import Base: promote_type

N = 11
v = fd.Volume(N, N, N)
v.velocities

vel = reshape(v.velocities, (size(v.velocities)..., 1))

NNlib.conv(vel, rand(3, 3, 11, 3))
NNlib.conv(rand(11, 11, 11, 1), rand(3, 3, 11, 3))


Base.promote_type(::Type{fd.Velocity}, ::Type{Float64}) = fd.Velocity

y = similar(vel, promote_type(eltype(vel), Float64))