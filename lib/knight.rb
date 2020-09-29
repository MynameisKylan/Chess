# knight.rb

require './lib/MovesGraph'
require './lib/move_permutation'
require './lib/piece'

class Knight < Piece
  @transformations = [[2, 1], [1, 2], [-1, 2], [2, -1], [-1, -2]]
  @moves = nil

  attr_reader :symbol, :color

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading Knight moves'
      begin
        load_moves
      rescue SystemCallError
        self.class.moves = MovesGraph.new(self.class.transformations)
        self.class.moves.build_graph
        save_moves
      end
      p 'Knight moves loaded'
    end
    @color = color
    @symbol = color == 'white' ? "\u2658".encode('utf-8') : "\u265E".encode('utf-8')
  end
  
  private

  def save_moves
    Dir.mkdir('lib/moves') unless Dir.exist?('lib/moves')
    filename = 'lib/moves/knight_moves.txt'
    File.open(filename, 'w') { |file| file.puts Marshal.dump(self.class.moves) }
  end

  def load_moves
    filename = 'lib/moves/knight_moves.txt'
    moves = Marshal.load(File.open(filename, 'r'))
    self.class.moves = moves
  end

end