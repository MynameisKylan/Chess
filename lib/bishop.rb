# bishop.rb

require './lib/move_permutations'
require './lib/MoveGraph'

class Bishop
  # filter for diagonal transformations
  @@transformations = MOVES.filter { |p| p[0].abs == p[1].abs }
  @@moves = nil

  def initialize
    if @@moves.nil?
      p 'loading Bishop moves'
      @@moves = MoveGraph.new(@@transformations)
      @@moves.build_graph
      p 'Bishop moves loaded'
    end
  end
end