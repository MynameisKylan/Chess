# queen_spec.rb

require './lib/queen'

describe Queen do
  let(:queen) { Queen.new }

  describe '#valid_move?' do
    it 'diagonal move is valid' do
      expect(queen.valid_move?([6, 6], [3, 3])).to be true
    end

    it 'lateral move is valid' do
      expect(queen.valid_move?([6, 6], [0, 6])).to be true
    end

    it 'vertical move is valid' do
      expect(queen.valid_move?([6, 6], [6, 0])).to be true
    end

    it 'returns false if move is invalid' do
      expect(
        queen.valid_move?(
          [0, 0],
          [7, 6]
        )
      ).to eql(false)
    end

    it 'returns false if destination is same as start' do
      expect(
        queen.valid_move?(
          [0, 0],
          [0, 0]
        )
      ).to eql(false)
    end
  end
end
