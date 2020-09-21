# rook.rb

require './lib/move_permutations'
require './lib/MoveGraph'
require './lib/piece'

class Rook < Piece
  # filter for straight-line transformations
  @@transformations = MOVES.filter { |p| p[0].zero? || p[1].zero? }
  @@moves = nil

  def initialize
    if @@moves.nil?
      p 'loading Rook moves'
      @@moves = MoveGraph.new(@@transformations)
      @@moves.build_graph
      p 'Rook moves loaded'
    end
  end
end