# king.rb

require './lib/move_permutations'
require './lib/MoveGraph'
require './lib/piece'

class King < Piece
  @transformations = (0..1).to_a.repeated_permutation(2).to_a
  @moves = nil

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize
    if self.class.moves.nil?
      p 'loading King moves'
      self.class.moves = MoveGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'King moves loaded'
    end
  end
end