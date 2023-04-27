pred addConstraint[w:Wall, i:Int, h:Int] {
  one c: Constraint | {
    c.wall = w
    c.index = i
    c.hint = h
  }
}

test expect {
  vacuity: {boardConstraints}
}

// test suite for GWNeverEating {
  
//     // TODO: Write 1 example that satsifies GWNeverEating
//     example neverEating is GWNeverEating for {
//         GWState = `S0 -- a trace with one state for simplicity
//         Goat = `G0 + `G1 + `G2
//         Wolf = `W0 + `W1 + `W2
//         GWAnimal = Goat + Wolf
//         -- constrain <gwshore> and <gwboat>
//         Near = `Near
//         Far = `Far
//         Position = Near + Far
//         gwshore = `S0 -> (`G0-> `Near +
//                         `G1-> `Near +
//                         `G2-> `Far +
//                         `W0-> `Far +
//                         `W1-> `Near +
//                         `W2-> `Near)
//         gwboat =`S0 -> `Near
//     }
// }

// test expect {
//     vacuity3: {StopAndCopyUnfragmentedWithAssumptions} for 9 Memory, 8 HeapCell, 5 Int is sat
// }