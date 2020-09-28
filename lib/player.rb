# player.rb

class Player
  attr_reader :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end

  def prompt_move
    print "#{name}, enter your move (see https://en.wikipedia.org/wiki/Chess#Notation_for_recording_moves for notation rules): "
  end

  def get_move
    gets.chomp
  end

  def valid_move_format?(move)
    patterns = /(^[a-h][1-8]$)|(^[KQNBR][a-h][1-8]$)|(^[KQNBR][a-hx][a-h][1-8]$)|(^[a-h]x[a-h][1-8]$)|(^O-O$)|(^O-O-O$)/
    return false unless patterns.match?(move)
    
    true
  end

end