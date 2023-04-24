#lang forge

abstract sig Wall {}

one sig Top extends Wall {}
one sig Bot extends Wall {}
one sig Lft extends Wall {}
one sig Rgt extends Wall {}

sig Cell {
  row : one Int,
  col : one Int,
  val : one Int
}

// Hint: you can access a queen's position by doing Board.position[r][c]
one sig Board {
    position : pfunc Int -> Int -> Cell,
    size : one Int
}

sig Constraint {
  wall : one Wall,
  index : one Int,
  hint : one Int
}




// Board Setup:
// Every row and col are unique
// X number of rows/cols

// Game rules:
// each val is unique within row/col
// "biggest seen yet" obeys constraint


-- Helper functions that return the left or right Chopstick of a given Smith
-- based on the representation that Chopstick N is to the left of Smith N
// fun leftChop[s : Smith]: Chopstick { Table.chops[Table.smiths.s] }
// fun rightChop[s : Smith]: Chopstick { Table.chops[remainder[add[Table.smiths.s, 1], 5]] }

pred withinBounds[n : Int] {
  n >= 0
  n < Board.size
}

pred boardSetup {

  all c:Cell | {
    // If you go to that row/col you get the cell
    Board.position[c.row][c.col] = c

    c.val > 0
    c.val <= Board.size
    
    c.row >= 0
    c.row < Board.size

    c.col >= 0
    c.col < Board.size
  }

  all i,j : Int | {
    // only valid cells present in Board.position
    (!withinBounds[i] or !withinBounds[j]) implies {
      no Board.position[i][j]
    }
  }

  all r:Int | {
    all disj a,b:Int | {
      (withinBounds[a] and withinBounds[b] and withinBounds[r]) => {(Board.position[r][a]).val != (Board.position[r][b]).val}
    }
  }

  all c:Int | {
    all disj a,b:Int | {
      (withinBounds[a] and withinBounds[b] and withinBounds[c]) => {(Board.position[a][c]).val != (Board.position[b][c]).val}
    }
  }

  all disj c1,c2 : Cell | {
    // all cells in different pos
    (c1.row != c2.row) or (c1.col != c2.col)
  }
}

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
  #{c:Cell | { 
    (const.wall = Top or const.wall = Bot) => {c.col = const.index} else {c.row = const.index}
    canBeSeen[c, const.wall]
    }} = const.hint
}


// here, fill in the board situation
pred boardConstraints {
  Board.size = 4
  one c: Constraint | {
    c.wall = Top
    c.index = 0
    c.hint = 4
  }

  one c: Constraint | {
    c.wall = Lft
    c.index = 2
    c.hint = 3
  }
}

run {
  boardConstraints
  boardSetup
  all c:Constraint | {
    obeysConstraint[c]
  }
} for exactly 16 Cell, 2 Constraint