#lang forge

// this was the failed attempt to make a Skyscraper solving assistant, making one move at a time. We realized that you would need to encode "human" solving logic, which kinda defeats the purpose of using Forge.

option problem_type temporal

sig Cell {
  row : one Int,
  col : one Int,
  var val : one Int,
  var options : set Int
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

pred withinBounds[n : Int] {
  n >= 0
  n < Board.size
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

pred puzzleRules {
  // // if a constraint's row/col is fully filled, then it satisfies constraint:
  all const:Constraint | {
    // count number of full cells in the row/col. if all full, then constraint must be obeyed
    (#{c:Cell |(
      (const.wall = Top or const.wall = Bot) => {c.col = const.index} else {c.row = const.index} and c.val != -1
    )} = Board.size) => obeysConstraint[const]
  }
}

// Sets up the game and the basic board rules 
// (all constraints that are not specific to a single puzzle instance)
pred boardSetup {

  Board.size = 6
  
  // constraints are valid
  all c: Constraint | {
    withinBounds[c.index]
    c.hint > 0
    c.hint <= Board.size
  }

  // cant have 2 constraints on the same slot
  all disj c1, c2: Constraint | {
    (c1.wall != c2.wall) or (c1.index !=  c2.index) 
  }

  all c:Cell | {
    // If you go to that row/col you get the cell
    Board.position[c.row][c.col] = c
    
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

  all disj c1,c2 : Cell | {
    // all cells in different pos
    (c1.row != c2.row) or (c1.col != c2.col)
  }

  all c:Cell | {
    c.options = {i : Int | i>0 and i<=Board.size}
  }
}

pred limitOptions[const: Constraint] {
  all c:Cell | {
    // if cell is in the relevant row/col
    ((const.wall=Top) and (c.col = const.index)) => {
      (Board.position[0][c.col]).options = {i:Int | i>0 and i<=add[subtract[Board.size, const.hint],1]}
    }
    ((const.wall=Bot) and (c.col = const.index)) => {
      (Board.position[subtract[Board.size,1]][c.col]).options = {i:Int | i>0 and i<=add[subtract[Board.size, const.hint],1]}
    }

    // ((const.wall=Left) and (c.col = const.index)) => {
    //   (Board.position[0][c.col]).options = {i:Int | i>0 and i<=add[subtract[Board.size, const.hint],1]}
    // }
    // ((const.wall=Bot) and (c.col = const.index)) => {
    //   (Board.position[subtract[Board.size,1]][c.col]).options = {i:Int | i>0 and i<=add[subtract[Board.size, const.hint],1]}
    // }

    //   ((const.wall = Top or const.wall = Bot) => {c.col = const.index} else {c.row = const.index}) => {
        
    //   }
  }
}


pred init {
  all c:Cell | {
    c.val = -1
  }
  boardSetup

  // all c:Constraint | {
  //   limitOptions[c]
  // }
}


pred doNothing {
  // guard: all cells filled
  all c:Cell | {
    c.val != -1
  }

  // action: nothing changes
  all c:Cell | {
    c.val' = c.val
    c.options' = c.options
  }
}

pred updatedBoard[chgd_c:Cell, val:Int] {
  // remove that option from the relevant cells
  all c : Cell | {
    ((c.row=chgd_c.row or c.col = chgd_c.col) and (c!=chgd_c)) => {c.options' = c.options-{val}}
  }
}

pred makeMove {
  // guard: some cell is not filled:
  some c:Cell | {
    c.val = -1
  }

  // action: make a move

  all c: Cell | {
    // all fixed cells stay fixed
    (c.val != -1) => {(c.val' = c.val)}

    //cant add random stuff to options
    c.options' in c.options
  }

  // one cell changes value
  one c: Cell | {
    // cell is not set yet
    c.val = -1

    // val changed
    c.val' != c.val

    // val changed from options
    c.val' in c.options

    // probably should clear the set of options but somehow not working...
    // #c.options' = 0
    c.options' = c.options

    // other cells are unchanged
    all c2: Cell | {
      (c2!=c) => {c2.val'=c2.val}
    }

    // if there are cells w/ only option, then picked from there:
    (#{oc:Cell | (#oc.options)=1}>0) => {c in {oc:Cell | (#oc.options)=1}}

    // update board as result of move:
    updatedBoard[c, c.val']
  }
}

pred traces {
	init
	always {
    puzzleRules
		makeMove or doNothing
	}
}

pred addConstraint[w:Wall, i:Int, h:Int] {
  one c: Constraint | {
    c.wall = w
    c.index = i
    c.hint = h
  }
}

run {
  // REMEMBER TO CHANGE BOARD.SIZE IF CHANGE CELL COUNT
  traces
  addConstraint[Top, 1, 1]
} for exactly 36 Cell, 1 Constraint