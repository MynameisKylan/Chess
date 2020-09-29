# bishop.rb

require './lib/MovesGraph'
require './lib/move_permutation'
require './lib/piece'

class Bishop < Piece
  # filter for diagonal transformations
  @transformations = MOVES.select { |p| p[0].abs == p[1].abs }
  @moves = nil

  attr_reader :symbol, :color

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading Bishop moves'
      begin
        load_moves
      rescue SystemCallError
        self.class.moves = MovesGraph.new(self.class.transformations)
        self.class.moves.build_graph(queue = [[0, 0], [0, 1]])
        save_moves
      end
      p 'Bishop moves loaded'
    end
    @color = color
    @symbol = color == 'white' ? "\u2657".encode('utf-8') : "\u265D".encode('utf-8')
  end

  private

  def save_moves
    Dir.mkdir('lib/moves') unless Dir.exist?('lib/moves')
    filename = 'lib/moves/bishop_moves.txt'
    File.open(filename, 'w') { |file| file.puts Marshal.dump(self.class.moves) }
  end

  def load_moves
    filename = 'lib/moves/bishop_moves.txt'
    moves = Marshal.load(File.open(filename, 'r'))
    self.class.moves = moves
  end
end