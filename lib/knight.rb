# knight.rb

require './lib/MovesGraph'
require './lib/move_permutation'
require './lib/piece'

class Knight < Piece
  @transformations = [[2, 1], [1, 2], [-1, 2], [2, -1], [-1, -2]]
  @moves = nil

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading Knight moves'
      self.class.moves = MovesGraph.new(self.class.transformations)
      self.class.moves.build_graph
      p 'Knight moves loaded'
    end
    @symbol = color == 'white' ? "\u2658".encode('utf-8') : "\u265E".encode('utf-8')
  end

end