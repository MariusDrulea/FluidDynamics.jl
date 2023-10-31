using NNlib

conv(rand(8, 8, 8, 5), rand(3, 3, 8, 8))

## 
k2 = rand(3, 3, 3, 1, 1)
v2 = pad_repeat(rand(8, 8, 8, 1, 1), (1, 1, 1, 1, 1, 1))    
conv(v2, k2)