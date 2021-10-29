require 'rails_helper'
RSpec.configure do |config|
  config.before(:all) do
    @subway_data = SubwayDescriptor.call
  end
end

RSpec.describe SubwayEngine::ResultPathCreator, type: :model do
  describe 'call for source and destination are not connection stations' do
    context 'source line and destination line intersect' do
      before(:all) do
        @source = "PORTALES"
        @destination = "PARQUE DE LOS VENADOS"
        @path_connections = {
          source_line: "LINEA 2",
          connections: [ {line: "LINEA 12", station: "ERMITA"} ]
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @path_connections)
      end

      it 'result path is not empty' do
        expect(@result_path).not_to be_empty
      end

      it 'result path has 2 segments' do
        expect(@result_path.size).to eq(2)
      end

      it 'first segment in result path is from PORTALES to ERMITA in LINEA 2 with direction TASQUENA and count stations 1' do
        expect(@result_path.first[:source]).to eq("PORTALES")
        expect(@result_path.first[:destination]).to eq("ERMITA")
        expect(@result_path.first[:line]).to eq("LINEA 2")
        expect(@result_path.first[:direction]).to eq("TASQUENA")
        expect(@result_path.first[:count_stations]).to eq(1)
      end

      it 'last segment in result path is from ERMITA to PARQUE DE LOS VENADOS in LINEA 12 with direction MIXCOAC and count stations 2' do
        expect(@result_path.last[:source]).to eq("ERMITA")
        expect(@result_path.last[:destination]).to eq("PARQUE DE LOS VENADOS")
        expect(@result_path.last[:line]).to eq("LINEA 12")
        expect(@result_path.last[:direction]).to eq("MIXCOAC")
        expect(@result_path.last[:count_stations]).to eq(2)
      end
    end

    context 'source line and destination line intersect through a third line' do
      before(:all) do
        @source = "PARQUE DE LOS VENADOS"
        @destination = "OBSERVATORIO"
        @path_connections = {
          source_line: "LINEA 12",
          connections: [ {line: "LINEA 7", station: "MIXCOAC"}, {line: "LINEA 1", station: "TACUBAYA"} ]
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @path_connections)
      end

      it 'result path is not empty' do
        expect(@result_path).not_to be_empty
      end

      it 'result path has 3 segments' do
        expect(@result_path.size).to eq(3)
      end

      it 'first segment in result path is from PARQUE DE LOS VENADOS to MIXCOAC in LINEA 12 with direction MIXCOAC' do
        expect(@result_path.first[:source]).to eq("PARQUE DE LOS VENADOS")
        expect(@result_path.first[:destination]).to eq("MIXCOAC")
        expect(@result_path.first[:line]).to eq("LINEA 12")
        expect(@result_path.first[:direction]).to eq("MIXCOAC")
        expect(@result_path.first[:count_stations]).to eq(4)
      end

      it 'second segment in result path is from MIXCOAC to TACUBAYA in LINEA 7 with direction EL ROSARIO' do
        expect(@result_path[1][:source]).to eq("MIXCOAC")
        expect(@result_path[1][:destination]).to eq("TACUBAYA")
        expect(@result_path[1][:line]).to eq("LINEA 7")
        expect(@result_path[1][:direction]).to eq("EL ROSARIO")
        expect(@result_path[1][:count_stations]).to eq(3)
      end

      it 'last segment in result path is from TACUBAYA to OBSERVATORIO in LINEA 1 with direction OBSERVATORIO' do
        expect(@result_path.last[:source]).to eq("TACUBAYA")
        expect(@result_path.last[:destination]).to eq("OBSERVATORIO")
        expect(@result_path.last[:line]).to eq("LINEA 1")
        expect(@result_path.last[:direction]).to eq("OBSERVATORIO")
        expect(@result_path.last[:count_stations]).to eq(1)
      end
    end
  end

  describe 'call when destination is connection station' do
    context 'source line and destination line intersect' do
      before(:all) do
        @source = "PORTALES"
        @destination = "SAN LAZARO"
        @path_connections = {
          source_line: "LINEA 2",
          connections: [ {line: "LINEA 1", station: "PINO SUAREZ"} ]
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @path_connections)
      end

      it 'result path is not empty' do
        expect(@result_path).not_to be_empty
      end

      it 'result path has 2 segments' do
        expect(@result_path.size).to eq(2)
      end

      it 'first segment in result path is from PORTALES to PINO SUAREZ in LINEA 2 with direction CUATRO CAMINOS' do
        expect(@result_path.first[:source]).to eq("PORTALES")
        expect(@result_path.first[:destination]).to eq("PINO SUAREZ")
        expect(@result_path.first[:line]).to eq("LINEA 2")
        expect(@result_path.first[:direction]).to eq("CUATRO CAMINOS")
        expect(@result_path.first[:count_stations]).to eq(7)
      end

      it 'last segment in result path is from PINO SUAREZ to SAN LAZARO in LINEA 1 with direction PANTITLAN' do
        expect(@result_path.last[:source]).to eq("PINO SUAREZ")
        expect(@result_path.last[:destination]).to eq("SAN LAZARO")
        expect(@result_path.last[:line]).to eq("LINEA 1")
        expect(@result_path.last[:direction]).to eq("PANTITLAN")
        expect(@result_path.last[:count_stations]).to eq(3)
      end
    end
  end
end