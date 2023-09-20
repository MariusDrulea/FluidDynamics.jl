struct Cell
    density::Float64
end

H, W, D = 8, 8, 8

zeros(8, 8, 8)
Matrix3 = Array{Cell, 3} # this is a typedef

volume = Matrix3(undef, H, W, D)

f = ()->Cell(rand())
f()

fill!(volume, Cell(rand()))

vals = rand(H, W, D)
volume = Cell.(vals)

rand()




