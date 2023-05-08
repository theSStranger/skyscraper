#lang forge

open "skyscraper.frg"

// This file verifies if some of the unique solution boards are in fact unique

// Excludes a given 4x4 board from the search space
pred excludeBoard[v0:Int, v1:Int, v2:Int, v3:Int, v4:Int, v5:Int, v6:Int, v7:Int, v8:Int, v9:Int, v10:Int, v11:Int, v12:Int, v13:Int, v14:Int, v15:Int] {
  (Board.position[0][0]).val != v0 or
  (Board.position[0][1]).val != v1 or
  (Board.position[0][2]).val != v2 or
  (Board.position[0][3]).val != v3 or
  (Board.position[1][0]).val != v4 or
  (Board.position[1][1]).val != v5 or
  (Board.position[1][2]).val != v6 or
  (Board.position[1][3]).val != v7 or
  (Board.position[2][0]).val != v8 or
  (Board.position[2][1]).val != v9 or
  (Board.position[2][2]).val != v10 or
  (Board.position[2][3]).val != v11 or
  (Board.position[3][0]).val != v12 or
  (Board.position[3][1]).val != v13 or
  (Board.position[3][2]).val != v14 or
  (Board.position[3][3]).val != v15
}

test suite for satsConstraints {
  test expect {
    // satisfying given constraints while excluding solution board is unsat => 
    // unique solution (all constraints on top, but could be on any side)

    //3, 2, 1, 4, 
    //4, 3, 2, 1, 
    //1, 4, 3, 2, 
    //2, 1, 4, 3
    unique3Constraint021324: {boardSetup[4] and excludeBoard[3, 2, 1, 4, 4, 3, 2, 1, 1, 4, 3, 2, 2, 1, 4, 3] and addConstraint[Top, 0, 2] and addConstraint[Top, 1, 3] and addConstraint[Top, 2, 4] and satsConstraints} for exactly 16 Cell is unsat

    //4, 2, 1, 3, 
    //1, 3, 2, 4, 
    //2, 4, 3, 1, 
    //3, 1, 4, 2
    unique3Constraint011324: {boardSetup[4] and excludeBoard[4, 2, 1, 3, 1, 3, 2, 4, 2, 4, 3, 1, 3, 1, 4, 2] and addConstraint[Top, 0, 1] and addConstraint[Top, 1, 3] and addConstraint[Top, 2, 4] and satsConstraints} for exactly 16 Cell is unsat

    // 3, 1, 2, 4, 
    // 4, 2, 3, 1, 
    // 1, 3, 4, 2, 
    // 2, 4, 1, 3
    unique4Constraint02142331: {boardSetup[4] and excludeBoard[3, 1, 2, 4, 4, 2, 3, 1, 1, 3, 4, 2, 2, 4, 1, 3] and addConstraint[Top, 0, 2] and addConstraint[Top, 1, 4] and addConstraint[Top, 2, 3] and addConstraint[Top, 3, 1] and satsConstraints} for exactly 16 Cell is unsat

  }
}