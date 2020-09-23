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
    @pieces = {}
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
    # checks for collision
    piece = @squares[from[0]][from[1]]
    return false unless piece.valid_move?(from, to)

    if piece.class != Knight
      trans = get_transformation(from, to)
      path = build_path(from, to, trans)
      return false unless path_empty?(path)
    end
    true
  end

  def display(color = 'white')
    # black pieces are solid color
    rows = @squares.map { |col| col.map { |piece| piece.nil? ? ' ' : piece.symbol } }.transpose
    rows = rows.reverse if color == 'white'
    rows = rows.map(&:reverse) if color == 'black'
    row_nums = color == 'black' ? (1..8).to_a : (1..8).to_a.reverse
    col_nums = color == 'black' ? ('A'..'H').to_a.reverse : ('A'..'H').to_a
    puts ' ' * 5 + '-' * 33
    rows.each do |row|
      puts ' ' * 4 + row_nums.shift.to_s + '| ' + row.join(' | ') + ' |'
      puts ' ' * 5 + '-' * 33
    end
    puts ' ' * 7 + col_nums.join('   ')
  end

  def add_piece(piece, square)
    @pieces[piece.class] ||= []
    @pieces[piece.class] << square
    @squares[square[0]][square[1]] = piece
  end

  def check?(color)
    king_square = get_location(King, color)

    squares = get_visible_squares(king_square)

    squares.each do |square|
      piece = get_piece(square)
      return true if piece.color != color && valid_move?(square, king_square)
    end
    false
  end

  private

  def get_visible_squares(king_square)
    # helper for #check?
    # get all squares that could be putting the king in check
    get_non_knight_squares(king_square) + get_knight_squares(king_square)
  end

  def get_non_knight_squares(king_square)
    squares = []
    transformations = (-1..1).to_a.repeated_permutation(2).to_a
    transformations.each do |trans|
      square = king_square
      loop do
        square = square.zip(trans).map { |pair| pair.reduce(&:+) }
        break if !valid_square?(square) || !empty?(square)
      end
      squares << square if valid_square?(square) && !empty?(square)
    end
    squares
  end

  def get_knight_squares(king_square)
    squares = []
    transformations = [[2, 1], [1, 2], [-1, 2], [-1, -2], [1, -2], [2, -1], [-2, -1], [-2, 1]]
    transformations.each do |trans|
      square = king_square.zip(trans).map { |pair| pair.reduce(&:+) }
      squares << square if valid_square?(square) && !empty?(square)
    end
    squares
  end

  def get_piece(square)
    @squares[square[0]][square[1]]
  end

  def valid_square?(square)
    square[0].between?(0, 7) && square[1].between?(0, 7)
  end

  def get_location(piece, color)
    @pieces[piece].detect { |loc| @squares[loc[0]][loc[1]].color == color }
  end

  def get_transformation(from, to)
    # helper for #valid_move?
    # get adjacent-square transformation required to build path between from and to
    trans = to.zip(from).map{ |pair| pair.reduce(&:-) }
    col = trans[0]
    row = trans[1]
    col = col.zero? ? 0 : col.abs / col
    row = row.zero? ? 0 : row.abs / row

    [col, row]
  end

  def build_path(from, to, transformation)
    # helper for #valid_move?
    # build path of every square between from and to given transformation vector
    position = from
    path = []
    loop do
      position = position.zip(transformation).map { |pair| pair.reduce(&:+) }
      break if position == to

      path << position
    end
    path
  end

  def path_empty?(path)
    # helper for #valid_move?
    path.all? { |square| empty?(square) }
  end
end