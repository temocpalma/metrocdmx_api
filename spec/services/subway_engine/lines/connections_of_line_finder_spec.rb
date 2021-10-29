require 'rails_helper'

RSpec.describe SubwayEngine::Lines::ConnectionsOfLineFinder, type: :model do
  describe 'call' do
    before(:all) do
      @subway_data = [
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
            {:name=>"L3S1", :coordinates=>"lat,lon"},
            {:name=>"L1S1", :coordinates=>"lat,lon"}
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
      ]
    end

    context 'when target_line is 1' do
      let(:target_line) { @subway_data.select { |line| line[:name] == "1" }  }
      let(:result) { SubwayEngine::Lines::ConnectionsOfLineFinder.call(target_line.first, @subway_data) }

      it 'returns connections lines = ["2", "3"]' do
        expect(result).to eq([{:line=>"2", :station=>"C12"}, {:line=>"3", :station=>"L1S1"}])
      end
    end

    context 'when target_line is 2' do
      let(:target_line) { @subway_data.select { |line| line[:name] == "2" }  }
      let(:result) { SubwayEngine::Lines::ConnectionsOfLineFinder.call(target_line.first, @subway_data) }

      it 'returns connections lines = ["1"]' do
        expect(result).to eq([{:line=>"1", :station=>"C12"}])
      end
    end

    context 'when target_line is X' do
      let(:target_line) { @subway_data.select { |line| line[:name] == "X" }  }
      let(:result) { SubwayEngine::Lines::ConnectionsOfLineFinder.call(target_line.first, @subway_data) }

      it 'returns connections lines = []' do
        expect(result).to be_empty
      end
    end
  end

end