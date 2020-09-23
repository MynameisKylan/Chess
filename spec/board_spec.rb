# board_spec.rb

require './lib/board'
require './lib/knight'

describe Board do
  let(:board) { Board.new }

  describe '#initialize' do
    it 'initializes @squares to be an 8x8 array of arrays' do
      expected = [[nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil]]

      expect(board.instance_variable_get(:@squares)).to eql(expected)
    end
  end

  describe '#add_piece' do
    it 'correctly adds piece to @squares' do
      knight = Knight.new
      board.add_piece(knight, [1, 4])
      expected = [[nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, knight, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil],
                  [nil, nil, nil, nil, nil, nil, nil, nil]]
      expect(board.instance_variable_get(:@squares)).to eql(expected)
    end
  end

  describe '#empty?' do
    it 'returns true if square is empty' do
      expect(board.empty?([2, 2])).to be true
    end

    it 'returns false if square has a piece' do
      board.add_piece(Knight.new, [2, 2])
      expect(board.empty?([2, 2])).to be false
    end
  end

  describe '#valid_move?' do
    context 'knight on C4 - ignores collision' do
      before(:all) do
        @board = Board.new
        @knight = Knight.new
        @board.add_piece(@knight, [2, 3])
      end

      it 'returns true if piece can be moved from destination to target' do
        expect(@board.valid_move?([2, 3], [1, 1])).to be true
        # expect(@board.valid_move?([2, 3], [0, 2])).to be true
        # expect(@board.valid_move?([2, 3], [0, 4])).to be true
        # expect(@board.valid_move?([2, 3], [3, 1])).to be true
      end

      it 'returns false if piece cannot reach target in one move' do
        expect(@board.valid_move?([2, 3], [3, 3])).to be false
      end
    end

    context 'queen on D4' do
      before(:all) do
        @board = Board.new
        @queen = Queen.new
        @board.add_piece(@queen, [4, 3])
        @board.add_piece(@queen, [5, 7])
        @board.add_piece(@queen, [1, 3])
      end

      it 'true for diagonal foward move' do
        expect(@board.valid_move?([4, 3], [7, 6])).to be true
      end

      it 'true for diagonal backwards downwards move' do
        expect(@board.valid_move?([4, 3], [1, 0])).to be true
      end

      it 'true for diagonal downwards move' do
        expect(@board.valid_move?([1, 3], [4, 0])).to be true
      end

      it 'true for diagonal backwards upwards move' do
        expect(@board.valid_move?([4, 3], [1, 6])).to be true
      end

      it 'true for lateral move' do
        expect(@board.valid_move?([4, 3], [4, 7])).to be true
      end

      it 'true for vertical move' do
        expect(@board.valid_move?([5, 7], [5, 0])).to be true
      end

      it 'true for straight-line backwards move' do
        expect(@board.valid_move?([4, 3], [2, 3])).to be true
      end

      it 'false for move not straight-line or diagonal' do
        expect(@board.valid_move?([4, 3], [0, 4])).to be false
      end

      it 'false if piece is in the way of straight-line' do
        @board.add_piece(Knight.new, [6, 3])
        expect(@board.valid_move?([4, 3], [7, 3])).to be false
      end

      it 'false if piece in in the way of diagonal' do
        @board.add_piece(Queen.new, [2, 1])
        expect(@board.valid_move?([4, 3], [1, 0])).to be false
      end
    end
  end

  describe '#check?' do
    context 'king on E1' do
      before(:each) do
        @board = Board.new
        @queen = Queen.new('white')
        @king = King.new('black')
        @board.add_piece(@king, [4, 0])
      end

      it 'black king is not in check' do
        expect(@board.check?('black')).to be false
      end

      context 'white queen on E8' do
        it 'black king is in straight-line check' do
          @board.add_piece(@queen, [4, 7])
          expect(@board.check?('black')).to be true
        end

        it 'check is blocked by another piece' do
          @board.add_piece(@queen, [4, 7])
          @board.add_piece(Queen.new('black'), [4, 3])
          expect(@board.check?('black')).to be false
        end
      end

      context 'white queen on A4' do
        it 'black king is in diagonal check' do
          @board.add_piece(@queen, [1, 3])
          expect(@board.check?('black')).to be true
        end
      end

      context 'white knight on G2' do
        it 'black king is in check by knight' do
          @board.add_piece(Knight.new('white'), [6, 1])
          expect(@board.check?('black')).to be true
        end
      end
    end
  end
end
