# MovesGraph_spec.rb

require './lib/MovesGraph'

describe MovesGraph do
  describe '#build_graph' do
    let(:transformations) { [-7, 7].repeated_permutation(2).to_a }
    let(:graph) { MovesGraph.new(transformations) }

    it 'populates @squares' do
      expect(graph.squares).not_to be_nil
    end

    it '@squares is a hash' do
      expect(graph.squares.class).to eql(Hash)
    end

    it '@squares has keys that are arrays of length 2' do
      expect(graph.squares.keys[0].class).to eql(Array)
      expect(graph.squares.keys[0].length).to eql(2)
    end

    it '@squares has values that are Sets' do
      expect(graph.squares[graph.squares.keys[0]].class).to eql(Set)
    end

    it '@squares is correct' do
      expected = MovesGraph.new(transformations).squares
      expected[[0, 0]] << [7, 7]
      expected[[7, 7]] << [0, 0]
      graph.build_graph

      expect(graph.squares).to eql(expected)
    end

    it '@squares is correct' do
      expected = MovesGraph.new([7, 0].repeated_permutation(2).to_a).squares
      expected[[0, 0]] << [7, 7]
      expected[[0, 0]] << [7, 0]
      expected[[0, 0]] << [0, 7]
      expected[[7, 0]] << [0, 0]
      expected[[7, 0]] << [7, 7]
      expected[[0, 7]] << [0, 0]
      expected[[0, 7]] << [7, 7]
      expected[[7, 7]] << [0, 0]
      expected[[7, 7]] << [7, 0]
      expected[[7, 7]] << [0, 7]

      graph = MovesGraph.new([7, 0].repeated_permutation(2).to_a)
      graph.build_graph
      expect(graph.squares).to eql(expected)
    end
  end
end