# pawn_spec.rb

describe Pawn do
  describe '#initialize' do
    context 'testing move graph' do
      before(:all) do
        pawn = Pawn.new
      end

      it 'pawn can move one step forward' do
        expect(Pawn.moves.squares[[4, 4]].include?([4, 5])).to be true
      end

      it 'pawn can move one step backward' do
        expect(Pawn.moves.squares[[4, 4]].include?([4, 3])).to be true
      end

      it 'pawn can move diagonally to capture' do
        expect(Pawn.moves.squares[[4, 4]].include?([5, 5])).to be true
      end

      it 'pawn cannot move laterally' do
        expect(Pawn.moves.squares[[4, 4]].include?([5, 4])).to be false
      end

      it 'pawn can move two moves if on starting square' do
        expect(Pawn.moves.squares[[5, 1]].include?([5, 3])).to be true
      end

      it 'pawn cannot move two squares if not on starting square' do
        expect(Pawn.moves.squares[[5, 2]].include?([5, 4])).to be false
      end
    end
  end
end