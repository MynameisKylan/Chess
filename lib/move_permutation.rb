# moves.rb
# Constant of all potential transformations a piece can have
# Shared across piece classes

MOVES = (-7..7).to_a.repeated_permutation(2).to_a