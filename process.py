# Open the file
with open('t.txt', 'r') as f:
  # Create an empty list
  numbers = []
  # Iterate over each line in the file
  for line in f:
    # Split the line into a list of strings
    line_list = line.split(':')
    # Get the first item in the list
    number = int(line_list[0])
    # Append the number to the list
    numbers.append(number)

# Print the list of numbers
# print(numbers)

print([(i-3)//4 for i in numbers])
hits = [(i-3)//4 for i in numbers]
c = 0
s = set()

chek = set()
for i1 in range(4):
  for h1 in range(1, 5):
    for i2 in range(i1, 4):
      for h2 in range(1, 5):
        for i3 in range(i2, 4):
          for h3 in range(1, 5):
            c += 1
            chek.add(f'{i1} {h1} {i2} {h2} {i3} {h3}')
            chek.add(reversed(f'{i1} {h1} {i2} {h2} {i3} {h3}'))
            if c in hits:
              # print(f'{i1} {h1}, {i2} {h2}, {i3} {h3}')
              s.add(f'{i1} {h1}, {i2} {h2}, {i3} {h3}')

# print(s)
for p in s:
  print(p)
# [index (in-range 0 4)]
#          [hint (in-range 1 5)]
#          [index2 (in-range index 4)]
#          [hint2 (in-range 1 5)]
#          [index3 (in-range index2 4)]
#          [hint3 (in-range 1 5)])