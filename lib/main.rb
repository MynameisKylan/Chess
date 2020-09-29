# driver script for a game of chess

require './lib/game'

def new_game
  game = Game.new
  game.add_players
  if game.prompt_load?
    begin
      puts "Loading #{filename}..."
      game.load_game(load_name)
      puts 'Loading Success!'
    rescue
      puts "#{load_name} save file not found. Starting new game."
      game.assign_colors
    end
  else
    game.assign_colors
  end

  ending = nil
  loop do
    game.play_turn
    if game.board.checkmate?(game.active_player.color)
      ending = 'checkmate'
      break
    elsif game.board.stalemate?(game.active_player.color)
      ending = 'stalemate'
      break
    else
      game.switch_active_player
    end
  end

  game.game_over(ending)
end

new_game