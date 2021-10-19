require 'rails_helper'

RSpec.describe SubwayEngine::StationIsInLineValidator, type: :model do
  describe 'call' do
    let(:line) {
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
    }

    context 'when station is included in line' do
      let(:target_station) { "C" }
      let (:result) { SubwayEngine::StationIsInLineValidator.call(target_station, line) }
      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'when station is not included in line' do
      let(:target_station) { "M" }
      let (:result) { SubwayEngine::StationIsInLineValidator.call(target_station, line) }
      it 'returns false' do
        expect(result).to be false
      end
    end
  end
end