require 'rails_helper'

RSpec.describe SubwayEngine::PathCalculator, type: :model do
  let(:subway_data) { [
    {
      :name=>"1",
      :stations=>[
        {:name=>"L1S1", :coordinates=>"lat,lon"},
        {:name=>"C12", :coordinates=>"lat,lon"}
      ]
    },
    {
      :name=>"2",
      :stations=>[
        {:name=>"L2S1", :coordinates=>"lat,lon"},
        {:name=>"L2S2", :coordinates=>"lat,lon"},
        {:name=>"L2S3", :coordinates=>"lat,lon"},
        {:name=>"C12", :coordinates=>"lat,lon"},
        {:name=>"L2S4", :coordinates=>"lat,lon"}
      ]
    },
    {
      :name=>"3",
      :stations=>[
        {:name=>"L3S1", :coordinates=>"lat,lon"}
      ]
    },
    {
      :name=>"X",
      :stations=>[
        {:name=>"A", :coordinates=>"1"},
        {:name=>"B", :coordinates=>"2"},
        {:name=>"C", :coordinates=>"3"},
        {:name=>"D", :coordinates=>"4"},
        {:name=>"E", :coordinates=>"5"}
      ]
    }
  ] }

  describe 'call' do
    context 'when source = B and destination = D are in the same line' do
      let(:source) { "B" }
      let(:destination) { "D" }
      let(:result) { SubwayEngine::PathCalculator.call(subway_data, source, destination)}
      it 'returns the path list is not empty' do
        expect(result).not_to be_empty
      end

      it 'returns the path list with a segment only' do
        expect(result.size).to eq(1)
      end

      it 'returns the segment with line X' do
        expect(result.first[:line]).to eq("X")
      end

      it 'returns the segment with direction to E' do
        expect(result.first[:direction]).to eq("E")
      end
    end

    context 'when source = C12 and destination = L2S2 are in the same line' do
      let(:source) { "C12" }
      let(:destination) { "L2S2" }
      let(:result) { SubwayEngine::PathCalculator.call(subway_data, source, destination)}
      it 'returns the path list is not empty' do
        expect(result).not_to be_empty
      end

      it 'returns the path list with a segment only' do
        expect(result.size).to eq(1)
      end

      it 'returns the segment with line 2' do
        expect(result.first[:line]).to eq("2")
      end

      it 'returns the segment with direction to L2S1' do
        expect(result.first[:direction]).to eq("L2S1")
      end
    end
  end
end