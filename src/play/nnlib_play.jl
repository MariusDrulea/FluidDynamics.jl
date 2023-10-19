using NNlib

# conv(rand(8, 8, 8, 5, 10), rand(3, 3, 3, 5, 10))
conv(rand(8, 8, 8, 1, 1), rand(3, 3, 3, 1, 1))
k2 = rand(3, 3, 3, 1, 1)
v2 = pad_repeat(rand(8, 8, 8, 1, 1), (1, 1, 1, 1, 1, 1))    

conv(v2, k2)