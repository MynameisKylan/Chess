# king.rb

require './lib/move_permutation'
require './lib/MovesGraph'
require './lib/piece'

class King < Piece
  @transformations = (0..1).to_a.repeated_permutation(2).to_a
  @moves = nil

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading King moves'
      self.class.moves = MovesGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'King moves loaded'
    end
    @can_castle = true
    @symbol = color == 'white' ? "\u2654".encode('utf-8') : "\u265A".encode('utf-8')
  end

  def can_castle?
    @can_castle
  end
end