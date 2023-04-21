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

        # EDIT HERE: If you need to initialize anything that should be shared across `solve` and `check_multiple`
        # feel free to add it here

    def skyscraper_counter(self, cells, clue):
        max_seen = Int('max_seen')
        self.s.add(max_seen == -1)
        count = Int('count')
        self.s.add(count == 0)

        for i in range(self.N):
            num = cells[i]
            new_max_seen = Int('new_max_seen_{}'.format(i))
            new_count = Int('new_count_{}'.format(i))

            self.s.add(If(num > max_seen, new_max_seen == num, new_max_seen == max_seen))
            self.s.add(If(num > max_seen, new_count == count + 1, new_count == count))

            max_seen = new_max_seen
            count = new_count

        self.s.add(count == clue)

    def solve(self):
        """PART 1"""

        # EDIT HERE: PART 1 CONSTRAINTS
        # Here, `self.N` is the size of the board, and `self.game_data` is the game data
        # Feel free to use `self.s.push()` and `self.s.pop()` across `solve` and `check_multiple`
        # to reset constraints if you don't want to reuse them in `check_multiple`

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
        for cage in self.game_data:
            wall, index, clue = cage["wall"], cage["index"], cage['clue']

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

        # Check for PART 1
        result = self.s.check()
        if result == sat:
            return get_grid(self.N, self.L, self.s.model())
        else:
            return None


    def check_multiple(self, ans):
        """PART 2"""

        # EDIT HERE: PART 2 CONSTRAINTS
        # Here, `self.N` is the size of the board, and `self.game_data` is the game data
        # Feel free to use `self.s.push()` and `self.s.pop()` across `solve` and `check_multiple`
        # to reset constraints if you don't want to reuse them in `check_multiple`
        # if ans is None:
        #     return False

        # different_cell_constraints = []
        # for i in range(self.N):
        #     for j in range(self.N):
        #         different_cell_constraints.append(self.L[i, j] != ans[i][j])

        # self.s.push()
        # self.s.add(Or(different_cell_constraints))
        # result = self.s.check()
        # self.s.pop()
        # return result == sat # Return True or False

if __name__ == "__main__":
    game_data_example = [
        dict(wall=0, index=1, clue=4),
        dict(wall=1, index=2, clue=3),
        dict(wall=2, index=3, clue=3),

    ]


    skyscraper = Skyscrapers(4, game_data_example)


    # PART 1
    ans = skyscraper.solve()
    
    print_grid(ans)
    # print_grid(ans2)
    # print_grid(ans3)
    # print_grid(ans4)

    # PART 2
    # print(kenken.check_multiple(ans))
    # print(kenken2.check_multiple(ans2))
    # print(kenken3.check_multiple(ans3))
    # print(kenken4.check_multiple(ans4))