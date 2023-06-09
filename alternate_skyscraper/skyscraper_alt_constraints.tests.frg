#lang forge

open "skyscraper_alt_constraints.frg"

// True if two cells in same row/col have same val
pred duplicateCells {
  some a:Int | {
    some disj b1,b2:Int | {
      withinBounds[a]
      withinBounds[b1]
      withinBounds[b2]
      ((Board.position[a][b1]).val = (Board.position[a][b2]).val) or ((Board.position[b1][a]).val = (Board.position[b2][a]).val)
    }
  }
}

test suite for boardSetup {
  test expect {
    vacuity: {boardSetup[4]} for exactly 16 Cell is sat

    // cell positions agree w cell values
    cellsArranged: {boardSetup[4] => {
      all i,j:Int | {
        some Board.position[i][j] => {(Board.position[i][j]).cell_row = i and (Board.position[i][j]).cell_col = j}
      }
    }} for exactly 16 Cell is theorem

    // cannot make boards that arent latin squares
    notLatinSquare: {boardSetup[4] and duplicateCells} for exactly 16 Cell is unsat

    // setting up the game always mplies the board cannot have duplicates
    alwaysLatinSquare: {boardSetup[4] => {not duplicateCells}} for exactly 16 Cell is theorem
    
  }
}

test suite for satsConstraints {
  test expect {
    // unsatisfiable constraints are indeed unsatisfiable
    conflictingConstr: {boardSetup[4] and satsConstraints and addWallConstraint[Top, 1, 4] and addWallConstraint[Bot, 1, 4]} for exactly 16 Cell is unsat

    // satsConstraints ensures that the final board obeys the puzzle constraints
    // here, these constraints should be unsolvable but we didn't force solver 
    // to obey them
    satsConstraintsNeeded: {boardSetup[4] and addWallConstraint[Top, 1, 4] and addWallConstraint[Bot, 1, 4]} for exactly 16 Cell is sat

    // example satisfiable constraint is satisfiable
    knownSatableConstr: {boardSetup[4] and addWallConstraint[Lft, 1, 2] and satsConstraints} for exactly 16 Cell is sat

    // known board that has exactly one solution, should find it
    knownUniqueSln: {boardSetup[4] and addWallConstraint[Rgt, 0, 3] and addWallConstraint[Rgt, 1, 2] and addWallConstraint[Rgt, 3, 4] and satsConstraints} for exactly 16 Cell is sat

    // example satisfiable constraint is satisfiable
    knownSatableConstr2: {boardSetup[4] and addInteriorConstraint[Lft, 1, 1, 2] and addInteriorConstraint[Rgt, 0, 1, 2] and addWallConstraint[Lft, 3, 4] and satsConstraints} for exactly 16 Cell is sat

    //satisfying a constraint implies certain cells can be seen
    trulyObeysConstraints: {(boardSetup[4] and addWallConstraint[Lft, 3, 4] and satsConstraints) => {
      canBeSeen[Board.position[3][0], Lft, 0] and 
      canBeSeen[Board.position[3][1], Lft, 0] and 
      canBeSeen[Board.position[3][2], Lft, 0] and 
      canBeSeen[Board.position[3][3], Lft, 0]}} for exactly 16 Cell is theorem

    //satisfying a constraint implies certain cells can be seen
    trulyObeysConstraints2: {(boardSetup[4] and addWallConstraint[Rgt, 3, 4] and satsConstraints) => {
      canBeSeen[Board.position[3][0], Rgt, 3] and 
      canBeSeen[Board.position[3][1], Rgt, 3] and 
      canBeSeen[Board.position[3][2], Rgt, 3] and 
      canBeSeen[Board.position[3][3], Rgt, 3]}} for exactly 16 Cell is theorem

    //satisfying a 3 constraint means only one cell cannot be seen
    trulyObeysConstraints3: {(boardSetup[4] and addWallConstraint[Top, 3, 3] and satsConstraints) => {
      one i:Int | {
        withinBounds[i]
        not canBeSeen[Board.position[i][3], Top, 0]
      }}
      } for exactly 16 Cell is theorem

    //satisfying a 2 constraint means only two cells cannot be seen
    trulyObeysConstraints4: {(boardSetup[4] and addWallConstraint[Bot, 2, 2] and satsConstraints) => {
      one disj i,j:Int | {
        i>j //need to include this since otherwise both (i,j) and (j,i) are valid, which breaks the 'one' constraint
        withinBounds[i]
        withinBounds[j]
        not canBeSeen[Board.position[i][2], Bot, 3]
        not canBeSeen[Board.position[j][2], Bot, 3]
      }}
      } for exactly 16 Cell is theorem

    //satisfying a 2 constraint from index 1 means only 1 cell cannot be seen
    trulyObeysInnerConstraint: {(boardSetup[4] and addInteriorConstraint[Top, 1, 1, 2] and satsConstraints) => {
      one j:Int | {
        j>=1
        withinBounds[j]
        not canBeSeen[Board.position[j][1], Top, 1]
      }}
      } for exactly 16 Cell is theorem

     //satisfying a 2 constraint means only two cells cannot be seen
    trulyObeysInnerConstraint2: {(boardSetup[4] and addInteriorConstraint[Lft, 1, 1, 1] and satsConstraints) => {
      one j:Int | {
        j>=1
        withinBounds[j]
        canBeSeen[Board.position[1][j], Lft, 1]
      }}
      } for exactly 16 Cell is theorem
  }
}

// tests to see that our modelling of the constraint mechanic is correct
test suite for canBeSeen {
  test expect {
    // If we dont force sat constraint, then we can have an incorrect board
    cantSeeExample: {boardSetup[4] and addWallConstraint[Top, 0, 1] and canBeSeen[Board.position[1][0], Top, 0]} for exactly 16 Cell is sat

    // We expect cell at 0,0 to be seen always with that given constraint
    canSeeExample: {(boardSetup[4] and addWallConstraint[Top, 0, 1] and satsConstraints) => canBeSeen[Board.position[0][0], Top, 0]} for exactly 16 Cell is theorem
    
    // We expect cell at 1,0 to never be seen with that constraint
    cantSeeExample: {(boardSetup[4] and addWallConstraint[Top, 0, 1] and satsConstraints) => not canBeSeen[Board.position[1][0], Top, 0]} for exactly 16 Cell is theorem
  }

  // verify cells can or cant be seen from certain positions
  example checkRow1 is (canBeSeen[`Cell0, `Lft, 0] and canBeSeen[`Cell1, `Lft, 0] and not canBeSeen[`Cell2, `Lft, 0]) for {
    Lft = `Lft
    Rgt = `Rgt
    Top = `Top
    Bot = `Bot
    Wall = Lft + Top + Rgt + Bot
    Cell = `Cell0 + `Cell1 + `Cell2 + `Cell3
    Board = `Board
    // single row board for simplicity: 1 3 2 4
    cell_row = `Cell0 -> 0 + `Cell1 -> 0 + `Cell2 -> 0 + `Cell3 -> 0
    cell_col = `Cell0 -> 0 + `Cell1 -> 1 + `Cell2 -> 2 + `Cell3 -> 3
    val = `Cell0 -> 1 + `Cell1 -> 3 + `Cell2 -> 2 + `Cell3 -> 4
    position = `Board -> (0 -> (0->`Cell0) + 0->(1->`Cell1) + 0->(2->`Cell2) + 0->(3->`Cell3))
    size = `Board -> 4
  }

  // verify all cells can/cant be seen from certain psns, bidirectionally in row
  example checkRow2 is (canBeSeen[`Cell0, `Lft, 0] and not canBeSeen[`Cell0, `Rgt, 3] and canBeSeen[`Cell1, `Lft, 0] and canBeSeen[`Cell1, `Rgt, 3] and not canBeSeen[`Cell2, `Lft, 0] and canBeSeen[`Cell2, `Rgt, 3]and not canBeSeen[`Cell3, `Lft, 0] and canBeSeen[`Cell3, `Rgt, 3]) for {
    Lft = `Lft
    Rgt = `Rgt
    Top = `Top
    Bot = `Bot
    Wall = Lft + Top + Rgt + Bot
    Cell = `Cell0 + `Cell1 + `Cell2 + `Cell3
    Board = `Board
    // single row board for simplicity: 3 4 2 1
    cell_row = `Cell0 -> 0 + `Cell1 -> 0 + `Cell2 -> 0 + `Cell3 -> 0
    cell_col = `Cell0 -> 0 + `Cell1 -> 1 + `Cell2 -> 2 + `Cell3 -> 3
    val = `Cell0 -> 3 + `Cell1 -> 4 + `Cell2 -> 2 + `Cell3 -> 1
    position = `Board -> (0 -> (0->`Cell0) + 0->(1->`Cell1) + 0->(2->`Cell2) + 0->(3->`Cell3))
    size = `Board -> 4
  }

  // verify all cells can/cant be seen from certain psns, bidirectionally in col
  example checkCol is (canBeSeen[`Cell0, `Top, 0] and not canBeSeen[`Cell0, `Bot, 3] and canBeSeen[`Cell1, `Top, 0] and canBeSeen[`Cell1, `Bot, 3] and not canBeSeen[`Cell2, `Top, 0] and canBeSeen[`Cell2, `Bot, 3]and not canBeSeen[`Cell3, `Top, 0] and canBeSeen[`Cell3, `Bot, 3]) for {
    Lft = `Lft
    Rgt = `Rgt
    Top = `Top
    Bot = `Bot
    Wall = Lft + Top + Rgt + Bot
    Cell = `Cell0 + `Cell1 + `Cell2 + `Cell3
    Board = `Board
    // single col board for simplicity: 3 4 2 1
    cell_col = `Cell0 -> 0 + `Cell1 -> 0 + `Cell2 -> 0 + `Cell3 -> 0
    cell_row = `Cell0 -> 0 + `Cell1 -> 1 + `Cell2 -> 2 + `Cell3 -> 3
    val = `Cell0 -> 3 + `Cell1 -> 4 + `Cell2 -> 2 + `Cell3 -> 1
    position = `Board -> (0 -> (0->`Cell0) + 1->(0->`Cell1) + 2->(0->`Cell2) + 3->(0->`Cell3))
    size = `Board -> 4
  }


  // verify all canBeSeen for interior constraints
  example checkCanBeSeenInterior is (canBeSeen[`Cell0, `Top, 0] and canBeSeen[`Cell0, `Bot, 0] and canBeSeen[`Cell1, `Top, 0] and canBeSeen[`Cell1, `Top, 1] and not canBeSeen[`Cell1, `Top, 2] and canBeSeen[`Cell2, `Bot, 3] and not canBeSeen[`Cell2, `Top, 1] and canBeSeen[`Cell3, `Bot, 3]) for {
    Lft = `Lft
    Rgt = `Rgt
    Top = `Top
    Bot = `Bot
    Wall = Lft + Top + Rgt + Bot
    Cell = `Cell0 + `Cell1 + `Cell2 + `Cell3
    Board = `Board
    // single col board for simplicity: 3 4 2 1
    cell_col = `Cell0 -> 0 + `Cell1 -> 0 + `Cell2 -> 0 + `Cell3 -> 0
    cell_row = `Cell0 -> 0 + `Cell1 -> 1 + `Cell2 -> 2 + `Cell3 -> 3
    val = `Cell0 -> 3 + `Cell1 -> 4 + `Cell2 -> 2 + `Cell3 -> 1
    position = `Board -> (0 -> (0->`Cell0) + 1->(0->`Cell1) + 2->(0->`Cell2) + 3->(0->`Cell3))
    size = `Board -> 4
  }


   // verify all cells can/cant be seen from certain psns, bidirectionally in row
  example checkCanBeSeenInterior2 is (canBeSeen[`Cell0, `Lft, 0] and canBeSeen[`Cell0, `Rgt, 0] and canBeSeen[`Cell1, `Lft, 0] and canBeSeen[`Cell1, `Lft, 1] and not canBeSeen[`Cell1, `Lft, 2] and canBeSeen[`Cell2, `Rgt, 3] and not canBeSeen[`Cell2, `Lft, 1] and canBeSeen[`Cell3, `Rgt, 3]) for {
    Lft = `Lft
    Rgt = `Rgt
    Top = `Top
    Bot = `Bot
    Wall = Lft + Top + Rgt + Bot
    Cell = `Cell0 + `Cell1 + `Cell2 + `Cell3
    Board = `Board
    // single row board for simplicity: 3 4 2 1
    cell_row = `Cell0 -> 0 + `Cell1 -> 0 + `Cell2 -> 0 + `Cell3 -> 0
    cell_col = `Cell0 -> 0 + `Cell1 -> 1 + `Cell2 -> 2 + `Cell3 -> 3
    val = `Cell0 -> 3 + `Cell1 -> 4 + `Cell2 -> 2 + `Cell3 -> 1
    position = `Board -> (0 -> (0->`Cell0) + 0->(1->`Cell1) + 0->(2->`Cell2) + 0->(3->`Cell3))
    size = `Board -> 4
  }
}