require 'rails_helper'
RSpec.configure do |config|
  config.before(:all) do
    @subway_data = SubwayDescriptor.call
  end
end

RSpec.describe SubwayEngine::Stations::DirectionBetweenStationsInLine, type: :model do
  describe 'call' do
    let(:target_line) { "LINEA 2" }
    let(:result) { SubwayEngine::Stations::DirectionBetweenStationsInLine.call(@subway_data, target_line, source, destination) }
    context 'when lines existing in line case direction 1' do
      let(:source) { "PORTALES" }
      let(:destination) { "XOLA" }

      it 'returns the direction equals to CUATRO CAMINOS' do
        expect(result).not_to be_nil
        expect(result).to eq("CUATRO CAMINOS")
      end
    end

    context 'when lines existing in line case direction inverse to 1' do
      let(:source) { "XOLA" }
      let(:destination) { "PORTALES" }

      it 'returns the direction equals to TASQUENA' do
        expect(result).not_to be_nil
        expect(result).to eq("TASQUENA")
      end
    end

    context 'when source and destination is the same' do
      let(:source) { "PORTALES" }
      let(:destination) { "PORTALES" }

      it 'returns a descriptive message' do
        expect(result).not_to be_nil
        expect(result).to eq("Source and Destination is the same")
      end
    end

    context 'when source does not exists in line' do
      let(:source) { "COYOACAN" }
      let(:destination) { "PORTALES" }

      it 'returns a descriptive message' do
        expect(result).to eq("COYOACAN does not exists in LINEA 2")
      end
    end
  end
end