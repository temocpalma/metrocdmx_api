require 'rails_helper'

RSpec.describe SubwayDescriptor, type: :model do
  describe 'call' do
    let(:data) { SubwayDescriptor.call }

    it 'returns a not empty data' do
      expect(data).not_to be_empty
    end

    it 'returns data with all lines' do
      expect(data.size).to eq(12)
      expect(data.first.keys).to eq([:name, :stations])
    end

    it 'returns 12 stations for line 2' do
      line2 = data.find do |line|
        line[:name] == "LINEA 2"
      end
      expect(line2).not_to be_empty
      expect(line2[:stations].size).to eq(24)
      expect(line2[:stations].first[:name]).to eq("CUATRO CAMINOS")
    end
  end
end