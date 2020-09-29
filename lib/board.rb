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
    @last_move = nil
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

  def legal_move?(from, to)
    return false unless valid_move?(from, to)

    # prevents moves that put you in check
    color = get_piece(from).color
    simulated_board = simulate_move(from, to)
    # simulated_board.display
    return false unless simulated_board.in_check(color).nil?

    true
  end

  def valid_move?(from, to)
    return false if from.nil? || to.nil? || from.empty?

    piece = get_piece(from)
    return false unless !piece.nil? && piece.valid_move?(from, to)

    # special pawn handling
    if piece.class == Pawn
      if diagonal_pawn?(piece, from, to)
        return true if valid_diagonal_pawn?(piece, from, to)

        return false
      end
    end

    # checks for collision - excluding knight
    destination = get_piece(to)
    if piece.class != Knight
      trans = get_transformation(from, to)
      path = build_path(from, to, trans)
    else
      path = []
    end
    return false unless path_empty?(path) && (destination.nil? || destination.color != piece.color)

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
    color = piece.color
    @pieces[color] ||= []
    @pieces[color] << square unless @pieces[color].include?(square)
    # p 'added ' + piece.to_s
    @squares[square[0]][square[1]] = piece
  end

  def in_check(color)
    # returns attacking squares or nil if not in check
    king_square = get_location(King, color)
    # p @pieces
    # p 'king_square = ' + king_square.to_s

    squares = get_visible_squares(king_square)

    attackers = []
    squares.each do |square|
      piece = get_piece(square)
      attackers << square if piece.color != color && valid_move?(square, king_square)
    end
    # p 'king_square = ' + king_square.to_s
    # p 'attackers = ' + attackers.to_s
    attackers.empty? ? nil : attackers
  end

  def checkmate?(color)
    attackers = in_check(color)
    return false if attackers.nil?
    # can king move out of check?
    king_square = get_location(King, color)
    king_moves = King.moves.squares[king_square].filter { |move| valid_move?(king_square, move) }
    # p 'king moves = ' + king_moves.to_s
    king_moves.each do |move|
      simulated_board = simulate_move(king_square, move)
      return false if simulated_board.in_check(color).nil?
    end
    # p 'king cannot move out of check'

    # can attacker(s) be blocked or captured?
    # p '@pieces = ' + @pieces.to_s
    defenders = @pieces[color]
    defenders.delete(king_square)
    # p 'defenders = ' + defenders.to_s
    attackers.each do |attacker_square|
      attacker = @squares[attacker_square[0]][attacker_square[1]]
      trans = get_transformation(king_square, attacker_square)
      path = attacker.class == Knight ? attacker_square : build_path(king_square, attacker_square, trans) << attacker_square
      # p 'path = ' + path.to_s
      path.each do |square|
        defenders.each do |defender_square|
          # p 'defender_square = ' + defender_square.to_s
          return false if valid_move?(defender_square, square)
        end
      end
    end
    true
  end

  def stalemate?(color)
    pieces = @pieces[color]
    # p pieces
    pieces.each do |square|
      moves = get_piece(square).class.moves.squares[square]
      moves.each do |move|
        # p move
        # p legal_move?(square, move)
        return false if legal_move?(square, move)
      end
    end
    true
  end

  def move_piece(from, to)
    piece = get_piece(from)
    target = get_piece(to)
    # can't check valid_move? for castling
    # return unless valid_move?(from, to)

    # update @pieces
    @pieces[target.color].delete(to) unless target.nil?
    @pieces[piece.color].delete(from)
    @pieces[piece.color] << to

    # update @squares
    @squares[to[0]][to[1]] = piece
    @squares[from[0]][from[1]] = nil

    @last_move = [from, to]

    promote(to, Queen) if piece.class == Pawn && (to[1].zero? || to[1] == 7)
  end

  def castle(color, side)
    king_square = get_location(King, color)
    king = get_piece(king_square)
    rook_x = side == 'queen' ? 0 : 7
    rook_y = king_square[1]
    rook_square = [rook_x, rook_y]
    rook = get_piece(rook_square)
    return unless king.can_castle? && rook.can_castle?

    trans = get_transformation(king_square, rook_square)
    path = build_path(king_square, rook_square, trans)
    return unless path_empty?(path)

    from = king_square
    current_board = self
    until path.empty?
      square = path.shift
      simulated_board = current_board.simulate_move(from, square)
      return unless simulated_board.in_check(color).nil?

      current_board = simulated_board
      from = square
    end
    if rook_x > king_square[0]
      new_king_square = [king_square[0] + 2, king_square[1]]
      new_rook_square = [new_king_square[0] - 1, king_square[1]]
    else
      new_king_square = [king_square[0] - 2, king_square[1]]
      new_rook_square = [new_king_square[0] + 1, king_square[1]]
    end
    move_piece(king_square, new_king_square)
    move_piece(rook_square, new_rook_square)
  end

  def simulate_move(from, to)
    # returns a copy of self with a move simulated
    board_copy = Marshal.load(Marshal.dump(self))
    board_copy.move_piece(from, to)

    board_copy
  end

  def human_move_to_coordinates(human_move, player)
    # examples: e4, Qh5, Nc6, Ngf3, Qxf7, O-O, O-O-O
    files = { 'a' => 0,
              'b' => 1,
              'c' => 2,
              'd' => 3,
              'e' => 4,
              'f' => 5,
              'g' => 6,
              'h' => 7 }
    pieces = { 'Q' => Queen,
               'K' => King,
               'N' => Knight,
               'B' => Bishop,
               'R' => Rook }
    parts = human_move.split('')
    if parts.length == 2 || parts.length == 4 && files.include?(parts[0])
      from, to = parse_pawn(parts, player, files)
    elsif parts.length == 3 || parts.length == 4
      from, to = parse_move(parts, player, files, pieces)
    end

    [from, to]
  end

  private

  def parse_move(parts, player, files, pieces)
    # returns from/to coordinates given human input
    # helper for human_move_to_coordinate
    if parts.length == 3
      piece, to_file, rank = parts
      from_file = nil
    elsif parts.length == 4
      piece, from_file, to_file, rank = parts
    end
    move = [files[to_file.downcase], rank.to_i - 1]
    if from_file.nil? || from_file == 'x'
      from = get_location(pieces[piece.upcase], player.color).filter { |loc| get_piece(loc).valid_move?(loc, move) }.flatten
    else
      from = get_location(pieces[piece.upcase], player.color).filter { |loc| loc[0] == files[from_file] }.flatten
    end
    to = move

    [from, to]
  end

  def parse_pawn(parts, player, files)
    # returns from/to coordinates for pawn given human input
    # helper for human_move_to_coordinate
    if parts.length == 2
      to = [files[parts[0]], parts[1].to_i - 1]
      from = get_location(Pawn, player.color).filter { |loc| loc[0] == files[parts[0]] }.reduce { |highest, nxt| nxt[1] > highest[1] && nxt[1] < parts[1].to_i - 1 ? nxt : highest}
    else
      to = [files[parts[2]], parts[3].to_i - 1]
      from = get_location(Pawn, player.color).filter { |loc| loc[0] == files[parts[0]] && get_piece(loc).valid_move?(loc, to) }.flatten
    end

    [from, to]
  end

  def promote(square, new_piece)
    old_piece = get_piece(square)
    color = old_piece.color
    add_piece(new_piece.new(color), square)
  end

  def diagonal_pawn?(piece, from, to)
    x_diff = to[0] - from[0]
    y_diff = to[1] - from[1]
    return false unless piece.class == Pawn && !x_diff.zero? && !y_diff.zero?

    true
  end

  def valid_diagonal_pawn?(piece, from, to)
    # en passant rules
    unless @last_move.nil?
      last_from = @last_move[0]
      last_to = @last_move[1]
      last_piece = get_piece(last_to)
      return true if (last_piece.class == Pawn) &&
        (last_piece.color != piece.color) &&
        (last_from[0] == from[0] + 1 || last_from[0] == from[0] - 1) &&
        (last_from[1] == from[1] + 2 || last_from[1] == from[1] - 2)&&
        (last_to[0] == to[0]) &&
        (last_to[1] == from[1])
    end
    !get_piece(to).nil? && get_piece(to).color != piece.color
  end

  def get_visible_squares(king_square)
    # helper for #in_check
    # get all squares that could be putting the king in check
    get_non_knight_squares(king_square) + get_knight_squares(king_square)
  end

  def get_non_knight_squares(king_square)
    # helper for #get_visible_squares
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
    # helper for #get_visible_squares
    squares = []
    transformations = [[2, 1], [1, 2], [-1, 2], [-1, -2], [1, -2], [2, -1], [-2, -1], [-2, 1]]
    transformations.each do |trans|
      square = king_square.zip(trans).map { |pair| pair.reduce(&:+) }
      squares << square if valid_square?(square) && !empty?(square)
    end
    squares
  end

  def get_piece(square)
    # helper for #get_visible_squares
    @squares[square[0]][square[1]]
  end

  def valid_square?(square)
    # helper for #get_visible_squares
    square[0].between?(0, 7) && square[1].between?(0, 7)
  end

  def get_location(piece, color)
    # helper for #get_visible_squares
    if piece == King
      return @pieces[color].detect { |loc| @squares[loc[0]][loc[1]].class == piece }
    end
    @pieces[color].filter { |loc| @squares[loc[0]][loc[1]].class == piece }
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

  def empty?(square)
    @squares[square[0]][square[1]].nil?
  end
end
