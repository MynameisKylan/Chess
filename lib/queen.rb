require './lib/move_permutation'
require './lib/MovesGraph'

class Queen
  # filter for diagonal or straight-line transformations
  @@transformations = MOVES.filter { |p| p[0].abs == p[1].abs || p[0].zero? || p[1].zero? }
  @@moves = nil

  def initialize()
    if @@moves.nil?
      p 'loading Queen moves'
      @@moves = MovesGraph.new(@@transformations)
      @@moves.build_graph
      p 'Queen moves loaded'
    end
  end
end