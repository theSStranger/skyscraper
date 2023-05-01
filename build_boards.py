pos_pos = []

# pos_pos: first index = position, second = value, third = perms w value at position
for i in range(4):
    pos_pos.append({'1':set(), '2':set(), '3':set(), '4':set()})

import itertools
perms = list(itertools.permutations(["1", "2", "3","4"]))

perms = [''.join(x) for x in perms]
print(perms)

for p in perms:
    for i in range(4):
        pos_pos[i][p[i]].add(p)

print(pos_pos)

# list(zip(*original[::-1]))

for p in perms:
    
    for i in range(3):