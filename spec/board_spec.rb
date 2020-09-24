# board_spec.rb

require './lib/board'

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

    context 'queen on D4, E8, and B4' do
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

      it 'false if target square is a friendly piece' do
        expect(@board.valid_move?([4, 3], [1, 3])).to be false
      end
    end
  end

  describe '#in_check' do
    context 'king on E1' do
      before(:each) do
        @board = Board.new
        @queen = Queen.new('white')
        @king = King.new('black')
        @board.add_piece(@king, [4, 0])
      end

      it 'black king is not in check' do
        expect(@board.in_check('black')).to be nil
      end

      context 'white queen on E8' do
        it 'black king is in straight-line check' do
          @board.add_piece(@queen, [4, 7])
          expect(@board.in_check('black')).to eql([[4, 7]])
        end

        it 'check is blocked by another piece' do
          @board.add_piece(@queen, [4, 7])
          @board.add_piece(Queen.new('black'), [4, 3])
          expect(@board.in_check('black')).to be nil
        end
      end

      context 'white queen on A4' do
        it 'black king is in diagonal check' do
          @board.add_piece(@queen, [1, 3])
          expect(@board.in_check('black')).to eql([[1, 3]])
        end
      end

      context 'white knight on G2' do
        it 'black king is in check by knight' do
          @board.add_piece(Knight.new('white'), [6, 1])
          expect(@board.in_check('black')).to eql([[6, 1]])
        end
      end
    end
  end

  describe '#checkmate?' do
    context 'king on D1' do
      before(:each) do
        @board = Board.new
        @king = King.new('black')
        @board.add_piece(@king, [3, 0])
      end

      it 'king can move out of check' do
        @board.add_piece(Queen.new('white'), [7, 0])
        expect(@board.checkmate?('black')).to be false
      end

      it 'king cannot move out of check' do
        @board.add_piece(Queen.new('white'), [7, 0])
        @board.add_piece(Rook.new('white'), [5, 1])
        expect(@board.checkmate?('black')).to be true
      end

      it 'rook can capture attacking queen' do
        @board.add_piece(Queen.new('white'), [7, 0])
        @board.add_piece(Rook.new('white'), [5, 1])
        @board.add_piece(Rook.new('black'), [7, 5])
        expect(@board.checkmate?('black')).to be false
      end

      it 'rook can block attacking queen' do
        @board.add_piece(Queen.new('white'), [7, 0])
        @board.add_piece(Rook.new('white'), [5, 1])
        @board.add_piece(Rook.new('black'), [6, 5])
        expect(@board.checkmate?('black')).to be false
      end

      it 'knight can capture attacking queen' do
        @board.add_piece(Queen.new('white'), [7, 0])
        @board.add_piece(Rook.new('white'), [5, 1])
        @board.add_piece(Knight.new('black'), [6, 2])
        expect(@board.checkmate?('black')).to be false
      end

      it 'knight can block attacking queen' do
        @board.add_piece(Queen.new('white'), [7, 0])
        @board.add_piece(Rook.new('white'), [5, 1])
        @board.add_piece(Knight.new('black'), [5, 2])
        expect(@board.checkmate?('black')).to be false
      end

      it 'knight cannot capture or block attacking queen' do
        @board.add_piece(Queen.new('white'), [7, 0])
        @board.add_piece(Rook.new('white'), [5, 1])
        @board.add_piece(Knight.new('black'), [6, 3])
        expect(@board.checkmate?('black')).to be true
      end

      it 'king can capture attacking queen' do
        @board.add_piece(Queen.new('white'), [4, 0])
        @board.add_piece(Queen.new('black'), [2, 0])
        @board.add_piece(Knight.new('black'), [3, 1])
        @board.add_piece(Knight.new('black'), [2, 1])
        expect(@board.checkmate?('black')).to be false
      end

      it 'king can move from multiple attackers' do
        @board.add_piece(Queen.new('white'), [6, 0])
        @board.add_piece(Queen.new('white'), [0, 3])
        expect(@board.checkmate?('black')).to be false
      end

      it 'smother mate' do
        @board.add_piece(Knight.new('black'), [2, 0])
        @board.add_piece(Pawn.new('black'), [3, 1])
        @board.add_piece(Pawn.new('black'), [2, 1])
        @board.add_piece(Pawn.new('black'), [4, 1])
        @board.add_piece(Knight.new('black'), [4, 0])
        @board.add_piece(Knight.new('white'), [5, 1])
        expect(@board.checkmate?('black')).to be true
      end

      it 'king can move from attacking knight' do
        @board.add_piece(Knight.new('white'), [5, 1])
        expect(@board.checkmate?('black')).to be false
      end
    end
  end

  describe '#stalemate?' do
    context 'king is only black piece on A8' do
      before(:all) do
        @board = Board.new
        @king = King.new('black')
        @board.add_piece(@king, [0, 7])
      end

      it 'king has no valid moves' do
        @board.add_piece(Queen.new('white'), [2, 6])
        expect(@board.stalemate?('black')).to be true
      end

      it 'king cannot move but pawn can' do
        @board.add_piece(Pawn.new('black'), [2, 3])
        expect(@board.stalemate?('black')).to be false
      end
    end
  end

  describe '#legal_move?' do
    before(:all) do
      @board = Board.new
      @king = King.new('black')
      @board.add_piece(@king, [0, 7])
      @board.add_piece(Queen.new('white'), [3, 6])
    end
    it 'false when king tries to move into check' do
      expect(@board.legal_move?([0, 7], [0, 6])).to be false
    end

    it 'false if moving defender puts king into check' do
      @board.add_piece(Queen.new('black'), [0, 5])
      @board.add_piece(Rook.new('white'), [0, 3])
      expect(@board.legal_move?([0, 5], [1, 5])).to be false
    end

    it 'true if not moving king into check' do
      @board.add_piece(Queen.new('black'), [1, 6])
      expect(@board.legal_move?([0, 7], [0, 6])).to be true
    end

    it 'true if not exposing king when moving defender' do
      @board.add_piece(Queen.new('black'), [1, 6])
      expect(@board.legal_move?([1, 6], [2, 6])).to be true
    end
  end
end
