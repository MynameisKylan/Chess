# bishop.rb

require './lib/move_permutations'
require './lib/MoveGraph'
require './lib/piece'

class Bishop < Piece
  # filter for diagonal transformations
  @transformations = MOVES.filter { |p| p[0].abs == p[1].abs }
  @moves = nil

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize
    if self.class.moves.nil?
      p 'loading Bishop moves'
      self.class.moves = MoveGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'Bishop moves loaded'
    end
  end
end