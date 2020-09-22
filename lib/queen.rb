# queen.rb

require './lib/move_permutation'
require './lib/MovesGraph'
require './lib/piece'

class Queen < Piece
  # filter for diagonal or straight-line transformations
  @transformations = MOVES.filter { |p| p[0].abs == p[1].abs || p[0].zero? || p[1].zero? }
  @moves = nil

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading Queen moves'
      self.class.moves = MovesGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'Queen moves loaded'
    end
    @symbol = color == 'white' ? "\u2655".encode('utf-8') : "\u265B".encode('utf-8')
  end
end