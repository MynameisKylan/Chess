# board.rb

require './lib/rook'
require './lib/knight'
require './lib/bishop'
require './lib/queen'
require './lib/king'
require './lib/pawn'

class Board
  def initialize
    @squares = Array.new(8) { Array.new(8) }
    @pieces = []
  end

  def populate_board
    add_piece(Rook.new('white'), [0, 0])
    add_piece(Rook.new('white'), [7, 0])
    add_piece(Knight.new('white'), [1, 0])
    add_piece(Knight.new('white'), [6, 0])
    add_piece(Bishop.new('white'), [2, 0])
    add_piece(Bishop.new('white'), [5, 0])
    add_piece(Queen.new('white'), [3, 0])
    add_piece(King.new('white'), [4, 0])
    8.times { |i| add_piece(Pawn.new('white'), [i, 1]) }

    add_piece(Rook.new('black'), [0, 7])
    add_piece(Rook.new('black'), [7, 7])
    add_piece(Knight.new('black'), [1, 7])
    add_piece(Knight.new('black'), [6, 7])
    add_piece(Bishop.new('black'), [2, 7])
    add_piece(Bishop.new('black'), [5, 7])
    add_piece(Queen.new('black'), [3, 7])
    add_piece(King.new('black'), [4, 7])
    8.times { |i| add_piece(Pawn.new('black'), [i, 6]) }
  end

  def empty?(square)
    @squares[square[0]][square[1]].nil?
  end

  def valid_move?(from, to)
    piece = @squares[from[0]][from[1]]
    return false unless piece.valid_move?(from, to)

    if piece.class != Knight
      trans = get_transformation(from, to)
      path = build_path(from, to, trans)
      return false unless path_empty?(path)
    end
    true
  end

  def display
    rows = @squares.map { |col| col.map { |piece| piece.nil? ? ' ' : piece.symbol } }.reverse.transpose
    puts '-' * 33
    rows.each do |row|
      puts '| ' + row.join(' | ') + ' |'
      puts '-' * 33
    end
  end

  private

  def add_piece(piece, square)
    @pieces << piece
    @squares[square[0]][square[1]] = piece
  end

  def get_transformation(from, to)
    # get adjacent-square transformation required to build path between from and to
    trans = to.zip(from).map{ |pair| pair.reduce(&:-) }
    col = trans[0]
    row = trans[1]
    col = col.zero? ? 0 : col.abs / col
    row = row.zero? ? 0 : row.abs / row

    [col, row]
  end

  def build_path(from, to, transformation)
    # build path of every square between from and to given transformation vector
    position = from
    path = []
    while position != to
      position = position.zip(transformation).map { |pair| pair.reduce(&:+) }
      path << position
    end
    path
  end

  def path_empty?(path)
    path.all? { |square| empty?(square) }
  end
end