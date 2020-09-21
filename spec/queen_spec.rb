# queen_spec.rb

require './lib/queen'

describe Queen do
  describe '#initialize' do
    it 'populates the @@moves class variable' do
      queen = Queen.new
      expect(Queen.class_variable_get(:@@moves)).not_to eql(nil)
    end
  end
end