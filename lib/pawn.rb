# pawn.rb

require './lib/MovesGraph'
require './lib/piece'

class Pawn < Piece
  # filter for straight-line transformations
  @transformations = [[-1, 1], [0, 1], [1, 1], [0, -1]]
  @moves = nil

  attr_reader :symbol, :color

  class << self
    attr_accessor :moves
    attr_reader :transformations
  end

  def initialize(color = 'white')
    if self.class.moves.nil?
      p 'loading Pawn moves'
      begin
        load_moves
      rescue SystemCallError
        self.class.moves = MovesGraph.new(self.class.transformations)
        self.class.moves.build_graph
        first_moves = generate_first_moves
        self.class.moves.add_edges(first_moves)
        save_moves
      end
      p 'Pawn moves loaded'
    end
    @color = color
    @symbol = color == 'white' ? "\u2659".encode('utf-8') : "\u265F".encode('utf-8')
  end

  def valid_move?(from, to)
    y_diff = to[1] - from[1]
    # ensure pawns are uni-directional
    return false if @color == 'white' && y_diff.negative?
    return false if @color == 'black' && y_diff.positive?

    super
  end

  private

  def save_moves
    Dir.mkdir('lib/moves') unless Dir.exist?('lib/moves')
    filename = 'lib/moves/pawn_moves.txt'
    File.open(filename, 'w') { |file| file.puts Marshal.dump(self.class.moves) }
  end

  def load_moves
    filename = 'lib/moves/pawn_moves.txt'
    moves = Marshal.load(File.open(filename, 'r'))
    self.class.moves = moves
  end

  def generate_first_moves
    first_moves = []
    (0..7).each do |col|
      first_moves << [[col, 1], [col, 3]]
      first_moves << [[col, 6], [col, 4]]
    end
    first_moves
  end
end
