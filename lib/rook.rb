# rook.rb

require './lib/MovesGraph'
require './lib/move_permutation'
require './lib/piece'

class Rook < Piece
  # filter for straight-line transformations
  @transformations = MOVES.filter { |p| p[0].zero? || p[1].zero? }
  @moves = nil

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize
    if self.class.moves.nil?
      p 'loading Rook moves'
      self.class.moves = MovesGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'Rook moves loaded'
    end
    @can_castle = true
  end

  def can_castle?
    @can_castle
  end
end