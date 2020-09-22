# piece.rb

class Piece
  def valid_move?(from, to)
    self.class.moves.squares[from].include?(to)
  end
end