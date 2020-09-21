require './lib/move_permutation'
require './lib/MovesGraph'

class Queen
  # filter for diagonal or straight-line moves
  @@transformations = MOVES.filter { |p| p[0].abs == p[1].abs || p[0] == 0 || p[1] == 0 }
  @@moves = nil
  def initialize()
    if @@moves.nil?
      p 'loading queen moves'
      @@moves = MovesGraph.new(@@transformations)
      @@moves.build_graph
      p 'queen loaded'
    end
  end
end