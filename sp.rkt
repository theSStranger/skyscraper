#lang forge

one sig N {
    n: one Int
}

pred valid {
    N.n > 1
    N.n < 3
}