# rook.rb

require './lib/MovesGraph'
require './lib/move_permutation'
require './lib/piece'

class Rook < Piece
  # filter for straight-line transformations
  @transformations = MOVES.filter { |p| p[0].zero? || p[1].zero? }
  @moves = nil

  attr_reader :symbol

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading Rook moves'
      self.class.moves = MovesGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'Rook moves loaded'
    end
    @can_castle = true
    @symbol = color == 'white' ? "\u2656".encode('utf-8') : "\u265C".encode('utf-8')
  end

  def can_castle?
    @can_castle
  end
end