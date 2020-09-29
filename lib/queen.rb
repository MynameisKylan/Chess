# queen.rb

require './lib/move_permutation'
require './lib/MovesGraph'
require './lib/piece'

class Queen < Piece
  # filter for diagonal or straight-line transformations
  @transformations = MOVES.select { |p| p[0].abs == p[1].abs || p[0].zero? || p[1].zero? }
  @moves = nil

  attr_reader :symbol, :color

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading Queen moves'
      begin
        load_moves
      rescue SystemCallError
        self.class.moves = MovesGraph.new(self.class.transformations)
        self.class.moves.build_graph
        save_moves
      end
      p 'Queen moves loaded'
    end
    @color = color
    @symbol = color == 'white' ? "\u2655".encode('utf-8') : "\u265B".encode('utf-8')
  end

  private

  def save_moves
    Dir.mkdir('lib/moves') unless Dir.exist?('lib/moves')
    filename = 'lib/moves/queen_moves.txt'
    File.open(filename, 'w') { |file| file.puts Marshal.dump(self.class.moves) }
  end

  def load_moves
    filename = 'lib/moves/queen_moves.txt'
    moves = Marshal.load(File.open(filename, 'r'))
    self.class.moves = moves
  end
end