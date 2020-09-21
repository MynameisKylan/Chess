class MovesGraph
  attr_reader :squares
  def initialize(start = [0,0], move_rules)
    @start = start
    # the set of transformations possible to move a piece
    @move_rules = move_rules
    @squares = initialize_squares
  end

  def build_graph(queue = [@start], seen = Set.new)
    start = queue.shift
    if @squares.keys.sort == seen.sort || start.nil?
      # pp @squares
      return
    elsif !seen.include?(start)
      possible_moves = []
      @move_rules.each do |transformation|
        move = transformation.zip(start).map { |pair| pair.sum }
        possible_moves << move
      end
      # p 'possible moves: ' + possible_moves.to_s
      possible_moves.each do |move|
        next if start == move

        # p 'evaluating move: ' + move.to_s
        if !seen.include?(start) && move[0].between?(0, 7) && move[1].between?(0,7)
          add_edge(start, move)
          add_edge(move, start)
          # p 'edge added: ' + move.to_s
          queue << move
        end
      end
      seen << start
    end

    build_graph(queue, seen)
  end

  private

  def add_edge(square1, square2)
    p "Added edge between #{square1} and #{square2}"
    @squares[square1] << square2
    @squares[square2] << square1
  end

  def initialize_squares
    squares = {}
    (0..7).each do |i|
      (0..7).each do |j|
        squares[[i, j]] = Set.new
      end
    end
    squares
  end

end