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

  describe '#valid_move?' do
    let(:white) { Pawn.new('white') }
    let(:black) { Pawn.new('black') }
    
    context 'testing first move rule' do
      it 'pawn can move two squares if it is first move' do
        expect(white.valid_move?([6, 1], [6, 3])).to be true
      end

      it 'pawn cannot move two square if not first move' do
        expect(white.valid_move?([6, 2], [6, 4])).to be false
      end
    end

    context 'testing directionality' do
      it 'white pawn can move in the (+) direction' do
        expect(white.valid_move?([3, 3], [3, 4])).to be true
      end

      it 'white pawn cannot move in the (-) direction' do
        expect(white.valid_move?([3, 3], [3, 2])).to be false
      end

      it 'black pawn can move in the (-) direction' do
        expect(black.valid_move?([5, 6], [5, 5])).to be true
      end

      it 'black pawn cannot move in the (+) direction' do
        expect(black.valid_move?([5, 6], [5, 7])).to be false
      end
    end
  end
end
