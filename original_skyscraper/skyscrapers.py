from z3 import *

def get_grid(N, L, model):
    """Consumes `N` (size of the board), `L` (dict mapping indices to z3 variables), `model` (z3 model)
    and returns a grid"""

    return [[int(str(model.evaluate(L[i, j]))) for j in range(N)] for i in range(N)]

def print_grid(grid):
    """Pretty-print the grid"""

    if grid is None:
        print("No solution!")
        return

    for row in grid:
        for col in row:
            print(col, end=" ")
        print()

class Skyscrapers(object):
    def __init__(self, N, game_data):
        """Constructor of this class"""

        self.N = N
        self.game_data = game_data

        # Solver
        self.s = Solver()

        # Grid Variables
        self.L = {(i, j): Int('var_{}_{}'.format(i, j)) for i in range(N) for j in range(N)}

    def skyscraper_counter(self, cells, clue):
        # Return maximum of a vector; error if empty, stolen from https://stackoverflow.com/questions/67043494/max-and-min-of-a-set-of-variables-in-z3py
        def max(vs):
            m = vs[0]
            for v in vs[1:]:
                m = If(v > m, v, m)
            return m

        # there should be X number of cells that have only smaller cells in front of it        
        self.s.add(Sum([If(cells[i] > max(cells[:i]), 1, 0) for i in range(self.N) if i>0]) == clue-1)

        # Sum([If(cells[i] > max(cells[:i]), 1, 0) for i in range(self.N) if i>0]) == clue-1 : a breakdown

        # max(cells[:i]) gives max of cells up to index i
        # If(cells[i] > max(cells[:i]), 1, 0) returns 1 if the number at i is greater than all numbers "before it"
        # Sum(... for i in range(...)) returns number of cells in this row/col which are greater than all predecessors, excluding the first cell which is always visible
        #  == clue - 1 : the -1 is because the above calculation doesnt include the very first cell which is always visible no matter what        

        
        
    def solve(self):
        # Each cell has a value between 1 and N (inclusive)
        for var in self.L.values():
            self.s.add(1 <= var, var <= self.N)

        # Row distinct values
        for i in range(self.N):
            self.s.add(Distinct([self.L[i, j] for j in range(self.N)]))

        # Column distinct values
        for j in range(self.N):
            self.s.add(Distinct([self.L[i, j] for i in range(self.N)]))

        # Outside constrains
        for const in self.game_data:
            wall, index, clue = const["wall"], const["index"], const['clue']

            if wall % 2 == 0:
                cells = [self.L[(x, index)] for x in range(self.N)]
                if wall == 0:
                    self.skyscraper_counter(cells, clue)
                else:
                    self.skyscraper_counter(cells[::-1], clue)
            else:
                cells = [self.L[(index, x)] for x in range(self.N)]
                if wall == 3:
                    self.skyscraper_counter(cells, clue)
                else:
                    self.skyscraper_counter(cells[::-1], clue)

        result = self.s.check()
        if result == sat:
            return get_grid(self.N, self.L, self.s.model())
        else:
            return None


if __name__ == "__main__":
    game_data_example = [
        dict(wall=0, index=1, clue=4),
        dict(wall=1, index=2, clue=3),
        dict(wall=2, index=3, clue=3),
    ]
    
    '''
      -  -  3  -
    -    4  2  1
    4 1  2  3  4
    - 4  3  1  2  3
    -    1  4
    
      -  4  -  -
    -    1  4  3  -
    -    2  3  4  -
    - 4  3  1  2  3
    -    4    1  -
      -  -  -  3
    '''
    game_data_hard = [
        dict(wall=0, index=0, clue=2),
        dict(wall=0, index=1, clue=4),
        dict(wall=0, index=2, clue=3),
        dict(wall=0, index=3, clue=1)
    ]

    skyscraper = Skyscrapers(4, game_data_hard)

    ans = skyscraper.solve()
    
    print_grid(ans)

    print(', '.join([str(ans[i][j]) for i in range(4) for j in range(4)]))