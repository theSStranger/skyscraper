#lang forge

// Cell Sig, stores position and value
sig Cell {
  row : one Int,
  col : one Int,
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

// Constraint Sig, stores game constraint including which wall, which index on 
//that wall, and what the hint is
sig Constraint {
  wall : one Wall,
  index : one Int,
  hint : one Int
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
  
  // constraints are valid
  all c: Constraint | {
    withinBounds[c.index]
    c.hint > 0
    c.hint <= Board.size
  }

  // cant have 2 constraints on the same slot
  all disj c1, c2: Constraint | {
    (c1.wall != c2.wall) or (c1.index != c2.index) 
  }

  all c:Cell | {
    // If you go to that row/col you get the cell
    Board.position[c.row][c.col] = c

    // all cell values in [1, Board.size]
    c.val > 0
    c.val <= Board.size
    
    // All cells on board
    withinBounds[c.row]
    withinBounds[c.col]
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
    (c1.row != c2.row) or (c1.col != c2.col)
  }
}

// Pred which determines if a given cell is visible from a given wall
pred canBeSeen[c : Cell, w: Wall] {
  // true when c is bigger than all cells before it
  all other:Int | {
    withinBounds[other] => {
      // looking down col
      (w=Top and other < c.row) => {
        (Board.position[other][c.col]).val < c.val
      }

      // looking up col
      (w=Bot and other > c.row) => {
        (Board.position[other][c.col]).val < c.val
      }

      // looking towards left
      (w=Rgt and other > c.col) => {
        (Board.position[c.row][other]).val < c.val
      }

      // looking towards right
      (w=Lft and other < c.col) => {
        (Board.position[c.row][other]).val < c.val
      }
    }
  }
}

// checks that a board constraint is sat
pred obeysConstraint[const : one Constraint] {
  // # of cells which can be seen on that specific row/col obeys the hint
  #{c:Cell | { 
    (const.wall = Top or const.wall = Bot) => {c.col = const.index} else {c.row = const.index}
    canBeSeen[c, const.wall]
    }} = const.hint
}

// predicate to add a specific constraint if desired
pred addConstraint[w:Wall, i:Int, h:Int] {
  one c: Constraint | {
    c.wall = w
    c.index = i
    c.hint = h
  }
}

// here, fill in the board situation
pred puzzleConstraints {
  addConstraint[Top, 0, 2]
  addConstraint[Top, 1, 4]
  addConstraint[Top, 2, 3]
}

// predicate to ensure that every constraint is obeyed.
pred satsConstraints {
  all c:Constraint | {
    obeysConstraint[c]
  }
}

// sample predicate to find sets of constraints with unique board layouts
pred diagonal {
  all i:Int | {
    withinBounds[i] => {
      (Board.position[i][i]).val = 4
    }
  }
}

run {
  // puzzleConstraints
  diagonal
  boardSetup[4]
  satsConstraints
} for exactly 16 Cell, 3 Constraint