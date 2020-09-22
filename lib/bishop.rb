# bishop.rb

require './lib/MovesGraph'
require './lib/move_permutation'
require './lib/piece'

class Bishop < Piece
  # filter for diagonal transformations
  @transformations = MOVES.filter { |p| p[0].abs == p[1].abs }
  @moves = nil

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading Bishop moves'
      self.class.moves = MovesGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'Bishop moves loaded'
    end
    @symbol = color == 'white' ? "\u2657".encode('utf-8') : "\u265D".encode('utf-8')
  end
end