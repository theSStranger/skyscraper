#lang forge "Filip" "Skyscraper Final Proj"

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

abstract sig Constraint {
  wall : one Wall,
  hint : one Int
}

// Constraint Sig, stores game constraint including which wall, which index on 
//that wall, and what the hint is
sig WallConstraint extends Constraint{
  index : one Int
}

sig InteriorConstraint extends Constraint {
  const_row : one Int,
  const_col : one Int
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
  all c: WallConstraint | {
    withinBounds[c.index]
    c.hint > 0
    c.hint <= Board.size
  }

  // cant have 2 constraints on the same slot
  all disj c1, c2: WallConstraint | {
    (c1.wall != c2.wall) or (c1.index != c2.index) 
  }

  // all interior constraints are valid
  all c: InteriorConstraint | {
    withinBounds[c.const_row]
    withinBounds[c.const_col]
    c.hint > 0
    // TODO: constraint this further to be <= the number of cells visible in given dir?
    c.hint <= Board.size
    (c.wall = Top) => (c.const_row > 0)
    (c.wall = Bot) => (c.const_row < subtract[Board.size,1])
    (c.wall = Lft) => (c.const_col > 0)
    (c.wall = Rgt) => (c.const_col < subtract[Board.size,1])

  }

  // interior constraints cant be facing same dir if in same cell
  all disj c1, c2: InteriorConstraint | {
    ((c1.const_row = c2.const_row) and (c1.const_col = c2.const_col)) => {c1.wall != c2.wall}
  }

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
pred obeysWallConstraint[const : one WallConstraint] {
  // # of cells which can be seen on that specific row/col obeys the hint
  #{c:Cell | { 
    (const.wall = Top or const.wall = Bot) => {c.cell_col = const.index} else {c.cell_row = const.index}
    (const.wall = Top or const.wall = Lft) => {canBeSeen[c, const.wall, 0]} else {canBeSeen[c, const.wall, subtract[Board.size, 1]]}
    }} = const.hint
}

// checks that an inner constraint is sat
pred obeysInteriorConstraint[const : one InteriorConstraint] {
  // # of cells which can be seen on that specific row/col obeys the hint
  #{c:Cell | { 
    (const.wall = Top or const.wall = Bot) => {c.cell_col = const.const_col and canBeSeen[c, const.wall, const.const_row]} else {c.cell_row = const.const_row and canBeSeen[c, const.wall, const.const_col]}
    }} = const.hint
}

pred addWallConstraint[w:Wall, i:Int, h:Int] {
  one c: WallConstraint | {
    c.wall = w
    c.index = i
    c.hint = h
  }
}

pred addInteriorConstraint[w:Wall, r:Int, c:Int, h:Int] {
  one wc: InteriorConstraint | {
    wc.wall = w
    wc.const_row = r
    wc.const_col = c
    wc.hint = h
  }
}

// here, fill in the board situation
pred puzzleConstraints {
  // one c:WallConstraint | {
  //   c.wall = Top
  //   c.hint = 3
  //   c.index = 1
  // }

  // one c:WallConstraint | {
  //   c.wall = Lft
  //   c.hint = 1
  //   c.index = 3
  // }

  // one c:WallConstraint | {
  //   c.wall = Bot
  //   c.hint = 1
  //   c.index = 0
  // }
}


pred satsConstraints {
  all c:InteriorConstraint | {
    obeysInteriorConstraint[c]
  }

  all c:WallConstraint | {
    obeysWallConstraint[c]
  }
}

pred diagonal {
  all i: Int | {
    withinBounds[i] => {
      (Board.position[i][i]).val = 4
    }
  }
}

run {
  puzzleConstraints
  boardSetup[4]
  satsConstraints
  // diagonal
  #{w:WallConstraint | 1=1} = 3
  
} for exactly 16 Cell, 3 WallConstraint