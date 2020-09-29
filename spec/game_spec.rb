# game_spec.rb
require './lib/game'

describe Game do
  before(:all) do
    @game = Game.new
  end

  describe '#add_players' do
    it 'adds players to @players' do
      allow(@game).to receive(:gets).and_return('dummy_name')
      @game.add_players
      expect(@game.players.length).to eql(2)
      expect(@game.players.all? { |p| p.class == Player }).to be true
    end
  end

  describe '#assign_colors' do
    it 'assigns white/black randomly to players' do
      @game.assign_colors
      expect(@game.players[0].color).not_to be nil
      expect(@game.players[1].color).not_to be nil
    end
  end
end