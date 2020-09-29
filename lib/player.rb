# player.rb

class Player
  attr_reader :name
  attr_accessor :color
  def initialize(name, color = nil)
    @name = name
    @color = color
  end

  def prompt_move
    print ">>>#{name}, enter your move: "
  end

  def get_move
    move = gets.chomp
    until valid_move_format?(move)
      puts "Invalid move format. Please see https://en.wikipedia.org/wiki/Chess#Notation_for_recording_moves for notation rules"
      prompt_move
      move = gets.chomp
    end
    move
  end

  def valid_move_format?(move)
    patterns = /(^[a-h][1-8]$)|(^[KQNBR][a-h][1-8]$)|(^[KQNBR][a-hx][a-h][1-8]$)|(^[a-h]x[a-h][1-8]$)|(^O-O$)|(^O-O-O$)/
    return false unless patterns.match?(move)
    
    true
  end

end