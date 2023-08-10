# Your team is writing a fancy new text editor and you've been tasked with implementing the line numbering.

# Write a function which takes a list of strings and returns each line prepended by the correct number.

# The numbering starts at 1. The format is n: string. Notice the colon and space in between.

# Examples: (Input --> Output)

# [] --> []
# ["a", "b", "c"] --> ["1: a", "2: b", "3: c"]

# out of place
def solution(strings):
    return [f"{i+1}: {strings[i]}" for i in range(len(strings))]

# in-place
def solution(strings):
    for i in range(len(strings)):
        strings[i] = f"{i+1}: {strings[i]}"
    return strings


# my_list = ['Hello', 'Hi', 'Goodbye']

# print('Solution 1:')
# print(solution1(my_list))
# print(my_list)

# print('Solution 2:')
# print(solution2(my_list))
# print(my_list)


