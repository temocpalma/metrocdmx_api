require 'rails_helper'

RSpec.describe SubwayEngine::IntersectionBetweenLinesFinder, type: :model do
  describe 'call' do
    context 'when intersection exists' do
      let(:source_lines) { ["12", "2"] }
      let(:destination_lines) { ["1", "2", "A"] }
      let(:result) { SubwayEngine::IntersectionBetweenLinesFinder.call(source_lines, destination_lines)}

      it 'returns not empty intersection' do
        expect(result).not_to be_empty
      end

      it 'returns intersection = ["2"]' do
        expect(result).to eq(["2"])
      end
    end

    context 'when intersection does not exists' do
      let(:source_lines) { ["12", "B"] }
      let(:destination_lines) { ["1", "2", "A"] }
      let(:result) { SubwayEngine::IntersectionBetweenLinesFinder.call(source_lines, destination_lines)}

      it 'returns empty intersection' do
        expect(result).to be_empty
      end
    end
  end
end