#lang forge

// Cell Sig, stores position and value
sig Cell {
  cell_row : one Int,
  cell_col : one Int,
  val : one Int
}

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

// Checks that an index is within the board's bounds
pred withinBounds[n : Int] {
  n >= 0
  n < Board.size
}

// Sets up the game and the basic board rules 
// (all constraints that are not specific to a single puzzle instance)
pred boardSetup[s : Int] {
  Board.size = s

  all c:Cell | {
    // If you go to that row/col you get the cell
    Board.position[c.cell_row][c.cell_col] = c

    // all cell values in [1, Board.size]
    c.val > 0
    c.val <= Board.size
    
    // All cells on board
    withinBounds[c.cell_row]
    withinBounds[c.cell_col]
  }

  all i,j : Int | {
    // only valid cells present in Board.position
    (!withinBounds[i] or !withinBounds[j]) implies {
      no Board.position[i][j]
    }
  }

  all piv:Int | {
    all disj a,b:Int | {
      // All cells in a given row/col have distinct values
      (withinBounds[a] and withinBounds[b] and withinBounds[piv]) => {
        (Board.position[piv][a]).val != (Board.position[piv][b]).val
        (Board.position[a][piv]).val != (Board.position[b][piv]).val
        }
    }
  }

  all disj c1,c2 : Cell | {
    // all cells in different pos
    (c1.cell_row != c2.cell_row) or (c1.cell_col != c2.cell_col)
  }
}

// Pred which determines if a given cell is visible from a given wall from a given index
pred canBeSeen[c : Cell, w: Wall, i: Int] {
  // true when c is bigger than all cells before it

  (w=Top) => {c.cell_row >= i}
  (w=Bot) => {c.cell_row <= i}
  (w=Lft) => {c.cell_col >= i}
  (w=Rgt) => {c.cell_col <= i}

  all other:Int | {
    withinBounds[other] => {
      // looking down col
      (w=Top and other < c.cell_row and other >=i) => {
        (Board.position[other][c.cell_col]).val < c.val
      }

      // looking up col
      (w=Bot and other > c.cell_row and other <= i) => {
        (Board.position[other][c.cell_col]).val < c.val
      }

      // looking towards left
      (w=Rgt and other > c.cell_col and other <= i) => {
        (Board.position[c.cell_row][other]).val < c.val
      }

      // looking towards right
      (w=Lft and other < c.cell_col and other >= i) => {
        (Board.position[c.cell_row][other]).val < c.val
      }
    }
  }
}

// checks that a board constraint is sat
pred obeysWallConstraint[wl:Wall, ht:Int, ix:Int] {
  // # of cells which can be seen on that specific row/col obeys the hint
  #{c:Cell | { 
    (wl = Top or wl = Bot) => {c.cell_col = ix} else {c.cell_row = ix}
    canBeSeen[c, wl, 0]
    }} = ht
}

// checks that an inner constraint is sat
pred obeysInteriorConstraint[wl:Wall, ht:Int, icr:Int, icc:Int] {
  // # of cells which can be seen on that specific row/col obeys the hint
  #{c:Cell | { 
    (wl = Top or wl = Bot) => {c.cell_col = sum[icc] and canBeSeen[c, wl, sum[icr]]} else {c.cell_row = sum[icr] and canBeSeen[c, wl, sum[icc]]}
    }} = sum[ht]
}