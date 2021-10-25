require 'rails_helper'

RSpec.describe SubwayEngine::Stations::CountBetweenStationsCalculator, type: :model do
  describe 'call' do
    let(:line) { {
      stations: [
        {name: "EL ROSARIO"},
        {name: "TEZOZOMOC"},
        {name: "FERRERIA"},
        {name: "NORTE 45"},
        {name: "VALLEJO"},
        {name: "INSTITUTO DEL PETROLEO"},
        {name: "LINDAVISTA"},
        {name: "DEPORTIVO 18 DE MARZO"},
        {name: "LA VILLA | BASILICA DE GUADALUPE"},
        {name: "MARTIN CARRERA"}
      ]
    } }

    let(:result) { SubwayEngine::Stations::CountBetweenStationsCalculator.call(line, station_one, station_two)}

    context 'when station are distinct' do
      let(:station_one) { "EL ROSARIO" }
      let(:station_two) { "LINDAVISTA" }

      it 'returns count = 6' do
        expect(result).to eq(6)
      end
    end

    context 'when station are the same' do
      let(:station_one) { "MARTIN CARRERA" }
      let(:station_two) { "MARTIN CARRERA" }

      it 'returns count = 0' do
        expect(result).to eq(0)
      end
    end

    context 'when some station does not exists in line' do
      let(:station_one) { "PORTALES" }
      let(:station_two) { "VALLEJO" }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end