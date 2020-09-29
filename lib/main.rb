# driver script for a game of chess

require './lib/game'

def new_game
  game = Game.new
  game.add_players
  if game.prompt_load?
    begin
      puts "Loading #{game.load_name}..."
      game.load_game(game.load_name)
      puts 'Loading Success!'
    rescue
      puts "#{game.load_name} save file not found. Starting new game."
      game.assign_colors
    end
  else
    game.assign_colors
  end

  ending = nil
  loop do
    game.play_turn
    if game.board.checkmate?(game.other_player.color)
      ending = 'checkmate'
      break
    elsif game.board.stalemate?(game.other_player.color)
      ending = 'stalemate'
      break
    else
      game.switch_active_player
      game.save_game if game.prompt_save?
    end
  end

  game.game_over(ending)
end

new_game