# bishop_spec.rb

require './lib/bishop'
require 'pp'

describe Bishop do
  describe '#valid_move?' do
    let(:bishop) { Bishop.new }

    it 'bishop can move in (+, +) direction' do
      expect(bishop.valid_move?([2, 0], [5, 3])).to be true
    end

    it 'bishop can move in (+, -) direction' do
      expect(bishop.valid_move?([2, 4], [5, 1])).to be true
    end

    it 'bishop can move in (-, +) direction' do
      expect(bishop.valid_move?([5, 0], [2, 3])).to be true
    end

    it 'bishop can move in (-, -) direction' do
      expect(bishop.valid_move?([5, 5], [2, 2])).to be true
      pp Bishop.moves
    end
  end
end