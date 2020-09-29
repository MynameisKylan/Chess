# game.rb

require './lib/board'
require './lib/player'

class Game
  attr_reader :players, :board, :active_player, :other_player
  def initialize(board = nil, players = [])
    @board = board.nil? ? Board.new : board
    @board.populate_board if board.nil?
    @players = players
  end

  def add_players
    [1, 2].each do |num|
      print "player #{num}, enter your name: "
      @players << Player.new(gets.chomp)
      puts ''
    end
  end

  def assign_colors
    colors = ['white', 'black'].shuffle
    @players.each do |p|
      p.color = colors.shift
    end
    white = @players.select { |p| p.color == 'white' }[0]
    @active_player = white
    @other_player = @players.select { |p| p.color == 'black' }[0]
    puts "-" * 30
    puts "#{white.name} is white and will go first"
    puts "-" * 30
  end

  def play_turn
    @board.display(@active_player.color)
    @active_player.prompt_move 
    from, to = nil
    move = @active_player.get_move
    from, to = @board.human_move_to_coordinates(move, @active_player)
    until @board.legal_move?(from, to)
      puts 'Illegal move. Please enter a legal move.'
      move = @active_player.get_move
      from, to = @board.human_move_to_coordinates(move, @active_player)
    end
    @board.move_piece(from, to)
    @board.display(@active_player.color)
    3.times { puts '-' * 30 }
  end

  def switch_active_player
    @active_player, @other_player = @other_player, @active_player
  end

  def game_over(condition)
    p "#{@active_player.name} is the winner by checkmate!" if condition == 'checkmate'
    p "It's a stalemate!" if condition == 'stalemate'
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exists?('saves')
    filename = 'saves/' + @players[0].name + '_' + @players[1].name + '_save.txt'
    save_file = File.open(filename, 'w') { |file| file.puts Marshal.dump(self) }
    puts 'Game successfully saved.'
  end

  def load_game(save_file)
    saved_game = Marshal.load(File.open(save_file, 'r').readlines)
    @board = saved_game.board
    @players = saved_game.players
    @active_player = saved_game.active_player
    puts 'Game successfully loaded.'
  end

  def prompt_save

  end

  def prompt_load?
    print 'Would you like to load a saved game? (y/n): '
    answer = nil
    until answer == 'y' || answer == 'n'
      answer = gets.chomp.downcase
    end
    return true if answer == 'y'
    return false if answer == 'n'
  end

  def load_name
    'saves/' + "#{players[0].name}" + '_' + "#{players[1].name}" + '_save.txt'
  end
end