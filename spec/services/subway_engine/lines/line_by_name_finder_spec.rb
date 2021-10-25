require 'rails_helper'

RSpec.describe SubwayEngine::Lines::LineByNameFinder, type: :model do
  let(:subway_data) { SubwayDescriptor.call }
  let(:result) { SubwayEngine::Lines::LineByNameFinder.call(subway_data, line_name)}
  describe 'call' do
    context 'when line exists' do
      let(:line_name) { "LINEA 6" }

      it 'returns the line' do
        expect(result).not_to be_empty
        expect(result[:name]).to eq(line_name)
      end
    end

    context 'when line does not exists' do
      let(:line_name) { "NOT EXISTS" }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end