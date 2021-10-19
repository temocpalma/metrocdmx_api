require 'rails_helper'

RSpec.describe SubwayEngine::DirectionBetweenStationsInLine, type: :model do
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
        {:name=>"C12", :coordinates=>"lat,lon"}
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

let(:target_line) { "X" }

let(:result) { SubwayEngine::DirectionBetweenStationsInLine.call(subway_data, target_line, source, destination) }

  describe 'call' do
    context 'when source is first than destination in the stations list' do
      let(:source) { "B" }
      let(:destination) { "D" }
      it 'returns the direction equals to E' do
        expect(result).not_to be_nil
        expect(result).to eq("E")
      end
    end

    context 'when source is after than destination in the stations list' do
      let(:source) { "D" }
      let(:destination) { "B" }
      it 'returns the direction equals to A' do
        expect(result).not_to be_nil
        expect(result).to eq("A")
      end
    end

    context 'when source and destination is the same' do
      let(:source) { "B" }
      let(:destination) { "B" }
      it 'returns the direction equals to A' do
        expect(result).not_to be_nil
        expect(result).to eq("Source and Destination is the same")
      end
    end
  end
end