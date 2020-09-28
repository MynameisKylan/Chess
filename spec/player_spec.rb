# player_spec.rb

describe Player do
  before(:all) do
    @player = Player.new('test', 'white')
  end

  describe '#verify_move_format' do
    it 'correctly matches pawn moves' do
      expect(@player.valid_move_format?('e4')).to be true
    end

    it 'correctly matches regular moves' do
      expect(@player.valid_move_format?('Ne4')).to be true
    end

    it 'correctly matches capture moves' do
      expect(@player.valid_move_format?('Nxe4')).to be true
    end

    it 'correctly matches file-specificed moves' do
      expect(@player.valid_move_format?('Nfe4')).to be true
    end

    it 'correctly matches king-side castle' do
      expect(@player.valid_move_format?('O-O')).to be true
    end

    it 'correctly matches queen-side castle' do
      expect(@player.valid_move_format?('O-O-O')).to be true
    end

    it 'correctly matches pawn capture' do
      expect(@player.valid_move_format?('exb6')).to be true
    end

    it 'doesn\'t match gibberish' do
      expect(@player.valid_move_format?('hello')).to be false
    end

    it 'doesn\'t match partially correct move' do
      expect(@player.valid_move_format?('Qxhh')).to be false
    end

    it 'doesn\'t match partially correct move' do
      expect(@player.valid_move_format?('Rfg9')).to be false
    end

    it 'doesn\'t match if move is too short' do
      expect(@player.valid_move_format?('Kf')).to be false
    end
  end
end