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
      end

      it 'true for diagonal foward move' do
        expect(@board.valid_move?([4, 3], [7, 6])).to be true
      end

      it 'true for diagonal backwards move' do
        expect(@board.valid_move?([4, 3], [1, 0])).to be true
      end

      it 'true for straight-line move' do
        expect(@board.valid_move?([4, 3], [4, 7])).to be true
      end

      it 'true for straight-line backwards move' do
        expect(@board.valid_move?([4, 3], [0, 3])).to be true
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

end
