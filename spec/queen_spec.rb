# queen_spec.rb

require './lib/queen'

describe Queen do
  let(:queen) { Queen.new }

  describe '#valid_move?' do
    it 'returns true if it is a valid move' do
      expect(
        queen.valid_move?(
          Queen.class_variable_get(:@@moves).squares,
          [0, 0],
          [6, 6]
        )
      ).to eql(true)
    end

    it 'returns false if move is invalid' do
      expect(
        queen.valid_move?(
          Queen.class_variable_get(:@@moves).squares,
          [0, 0],
          [7, 6]
        )
      ).to eql(false)
    end

    it 'returns false if destination is same as start' do
      expect(
        queen.valid_move?(
          Queen.class_variable_get(:@@moves).squares,
          [0, 0],
          [0, 0]
        )
      ).to eql(false)
    end
  end
end
