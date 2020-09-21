# MovesGraph_spec.rb

require './lib/MovesGraph'

describe MovesGraph do
  describe '#build_graph' do
    let(:transformations) { (-1..1).to_a.repeated_permutation(2).to_a }
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
  end
end