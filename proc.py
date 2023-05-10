numbers_list = []

with open('./original_skyscraper/unique_boards/unique_three_constraint_one_side_boards.txt', 'r') as f:
    for line in f:
        if "SUCCESS" in line:
            numbers = line[line.find("SUCCESS ")+8:line.find("SUCCESS")+20].split()
            print("addConstraint[Top, " + numbers[0] + ", " + numbers[1] + "]")
            print("addConstraint[Top, " + numbers[2] + ", " + numbers[3] + "]")
            print("addConstraint[Top, " + numbers[4] + ", " + numbers[5] + "]")
            print()

