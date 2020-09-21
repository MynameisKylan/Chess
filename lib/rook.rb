# rook.rb

require './lib/move_permutations'
require './lib/MoveGraph'

class Rook
  # filter for straight-line transformations
  @@transformations = MOVES.filter { |p| p[0].zero? || p[1].zero? }
  @@moves = nil

  def initialize
    if @@moves.nil?
      p 'loading rook moves'
      @@moves = MoveGraph.new(@@transformations)
      @@moves.build_graph
      p 'rook moves loaded'
    end
  end
end