#lang forge

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
  wall : one Int,
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

pred boardSetup {

  all c:Cell | {
    // If you go to that row/col you get the cell
    Board.position[c.row][c.col] = c

    c.val > 0
    c.val <= Board.size
    
    c.row > 0
    c.row <= Board.size

    c.col > 0
    c.col <= Board.size
  }

  
  all r: Int |{
    // unique vals across rows
    all disj a, b: Int | {
        (Board.position[r][a]).val != (Board.position[r][b]).val
    }
  }

  all c: Int |{
    // unique vals across cols
    all disj a, b: Int | {
        (Board.position[a][c]).val != (Board.position[b][c]).val
    }
  }

  all disj c1,c2 : Cell | {
    // all cells in different pos
    (c1.row != c2.row) or (c1.col != c2.col)
  }

}


// checks that a board constraint is sat
pred obeysConstraint[c : one Constraint] {

}


// here, fill in the board situation
pred boardConstraints {
  // Board.size = 2
}

run {
  boardConstraints
  boardSetup
} for exactly 4 Cell