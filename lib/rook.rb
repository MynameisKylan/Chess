# rook.rb

require './lib/move_permutations'
require './lib/MoveGraph'
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
      self.class.moves = MoveGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'Rook moves loaded'
    end
  end
end