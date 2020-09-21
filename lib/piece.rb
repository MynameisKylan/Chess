# piece.rb

class Piece
  def valid_move?(moves, from, to)
    moves[from].include?(to)
  end
end