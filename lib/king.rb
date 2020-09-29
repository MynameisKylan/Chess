# king.rb

require './lib/move_permutation'
require './lib/MovesGraph'
require './lib/piece'

class King < Piece
  @transformations = (-1..1).to_a.repeated_permutation(2).to_a
  @moves = nil

  attr_reader :symbol, :color

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading King moves'
      begin
        load_moves
      rescue SystemCallError
        self.class.moves = MovesGraph.new(self.class.transformations)
        self.class.moves.build_graph
        save_moves
      end
      p 'King moves loaded'
    end
    @color = color
    @can_castle = true
    @symbol = color == 'white' ? "\u2654".encode('utf-8') : "\u265A".encode('utf-8')
  end

  def can_castle?
    @can_castle
  end

  private

  def save_moves
    Dir.mkdir('lib/moves') unless Dir.exist?('lib/moves')
    filename = 'lib/moves/king_moves.txt'
    File.open(filename, 'w') { |file| file.puts Marshal.dump(self.class.moves) }
  end

  def load_moves
    filename = 'lib/moves/king_moves.txt'
    moves = Marshal.load(File.open(filename, 'r'))
    self.class.moves = moves
  end
end