# knight.rb

require './lib/MovesGraph'
require './lib/move_permutation'

class Knight
  @@transformations = [[2, 1], [1, 2], [-1, 2], [2, -1]]
  @@moves = nil
  def initialize
    if !@@moves
      p 'loading Knight moves'
      @@moves = MovesGraph.new(@@transformations)
      @@moves.build_graph
      p 'Knight moves loaded'
    end
  end

end