numbers_list = []

# with open('./original_skyscraper/unique_boards/unique_three_constraint_one_side_boards.txt', 'r') as f:
#     for line in f:
#         if "SUCCESS" in line:
#             numbers = line[line.find("SUCCESS ")+8:line.find("SUCCESS")+20].split()
#             print("addConstraint[Top, " + numbers[0] + ", " + numbers[1] + "]")
#             print("addConstraint[Top, " + numbers[2] + ", " + numbers[3] + "]")
#             print("addConstraint[Top, " + numbers[4] + ", " + numbers[5] + "]")
#             print()

with open('t.txt', 'r') as f:
    for line in f:
        n = line.split()
        print("one c:InnerConstraint | {")
        print("\tc.wall="+n[0])
        print("\tc.hint="+n[1])
        print("\tc.const_row="+n[2])
        print("\tc.const_col="+n[3])
        print("}")
        print()
# wall hint const_row const_col


# Bot 2 2 3
# wall hint row col

# one c:WallConstraint | {
#     c.wall = Bot
#     c.hint = 1
#     c.index = 0
#   }