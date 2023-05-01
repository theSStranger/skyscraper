#lang forge

// Wall sig to specify location of puzzle constraint
abstract sig Wall {}

one sig Top extends Wall {}
one sig Bot extends Wall {}
one sig Lft extends Wall {}
one sig Rgt extends Wall {}

// Board Sig, stores cell positions and board size
one sig Board {
    position : pfunc Int -> Int -> Cell,
    size : one Int
}

// Constraint Sig, stores game constraint including which wall, which index on 
//that wall, and what the hint is
sig Constraint {
  wall : one Wall,
  index : one Int,
  hint : one Int
}
