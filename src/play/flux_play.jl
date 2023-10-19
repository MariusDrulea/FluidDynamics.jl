using Flux
using NNlib

x = rand(8, 8, 8, 5)

c1 = Conv((3, 3), 8=>10)
@show size(c1.weight)

c1(x)
NNlib.conv(rand(8, 8, 8, 5), rand(3, 3, 8, 10))