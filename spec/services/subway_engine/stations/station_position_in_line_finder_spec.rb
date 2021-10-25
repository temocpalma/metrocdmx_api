require 'rails_helper'

RSpec.describe SubwayEngine::Stations::StationPositionInLineFinder, type: :model do
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

    let(:result) { SubwayEngine::Stations::StationPositionInLineFinder.call(line, station)}

    context 'when station is first' do
      let(:station) { "EL ROSARIO" }

      it 'returns position 0' do
        expect(result).to eq(0)
      end
    end

    context 'when station is last' do
      let(:station) { "MARTIN CARRERA" }

      it 'returns last position' do
        expect(result).to eq(line[:stations].size - 1)
      end
    end

    context 'when station is the third' do
      let(:station) { "FERRERIA" }

      it 'returns position 2' do
        expect(result).to eq(2)
      end
    end

    context 'when station does not exists in line' do
      let(:station) { "PORTALES" }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end