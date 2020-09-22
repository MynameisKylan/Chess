# board.rb

class Board
  def initialize
    @squares = Array.new(8) { Array.new(8) }
    @pieces = []
  end

  def add_piece(piece, square)
    @pieces << piece
    @squares[square[0]][square[1]] = piece
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

  private

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