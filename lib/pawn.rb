# pawn.rb

require './lib/MovesGraph'
require './lib/piece'

class Pawn < Piece
  # filter for straight-line transformations
  @transformations = [[-1, 1], [0, 1], [1, 1], [0, 2]]
  @moves = nil

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize
    if self.class.moves.nil?
      p 'loading Pawn moves'
      self.class.moves = MovesGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'Pawn moves loaded'
    end
    @first_move = true
  end

  def first_move?
    @first_move
  end
end