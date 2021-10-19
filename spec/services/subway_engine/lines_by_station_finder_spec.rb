require 'rails_helper'

RSpec.describe SubwayEngine::LinesByStationFinder, type: :model do
  describe 'call' do
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
        :stations=>[{:name=>"L3S1", :coordinates=>"lat,lon"}]
      }
    ] }

    context 'when station target is C12' do
      let(:station_target) { "C12" }
      let(:result) { SubwayEngine::LinesByStationFinder.call(subway_data, station_target) }
      it 'returns 1 y 2' do
        expect(result).to eq(["1", "2"])
      end
    end

    context 'when station target is L1S1' do
      let(:station_target) { "L1S1" }
      let(:result) { SubwayEngine::LinesByStationFinder.call(subway_data, station_target) }
      it 'returns 1' do
        expect(result).to eq(["1"])
      end
    end
  end
end