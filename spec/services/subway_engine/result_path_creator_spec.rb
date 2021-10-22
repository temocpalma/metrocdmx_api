require 'rails_helper'

RSpec.describe SubwayEngine::ResultPathCreator, type: :model do
  let(:subway_data) { SubwayDescriptor.call }
  describe 'call for source and destination are not connection stations' do
    context 'source line and destination line intersect' do
      let(:source) { "PORTALES" }
      let(:destination) { "PARQUE DE LOS VENADOS" }
      let(:path_connections) { {
        source_line: "LINEA 2",
        connections: [ {line: "LINEA 12", station: "ERMITA"} ]
      } }
      let(:result_path) { SubwayEngine::ResultPathCreator.call(subway_data, source, destination, path_connections) }

      it 'result path is not empty' do
        expect(result_path).not_to be_empty
      end

      it 'result path has 2 segments' do
        expect(result_path.size).to eq(2)
      end

      it 'first segment in result path is from PORTALES to ERMITA in LINEA 2 with direction TASQUENA' do
        expect(result_path.first[:source]).to eq("PORTALES")
        expect(result_path.first[:destination]).to eq("ERMITA")
        expect(result_path.first[:line]).to eq("LINEA 2")
        expect(result_path.first[:direction]).to eq("TASQUENA")
      end

      it 'last segment in result path is from ERMITA to PARQUE DE LOS VENADOS in LINEA 12 with direction MIXCOAC' do
        expect(result_path.last[:source]).to eq("ERMITA")
        expect(result_path.last[:destination]).to eq("PARQUE DE LOS VENADOS")
        expect(result_path.last[:line]).to eq("LINEA 12")
        expect(result_path.last[:direction]).to eq("MIXCOAC")
      end
    end

    context 'source line and destination line intersect through a third line' do
      let(:source) { "PARQUE DE LOS VENADOS" }
      let(:destination) { "OBSERVATORIO" }
      let(:path_connections) { {
        source_line: "LINEA 12",
        connections: [ {line: "LINEA 7", station: "MIXCOAC"}, {line: "LINEA 1", station: "TACUBAYA"} ]
      } }
      let(:result_path) { SubwayEngine::ResultPathCreator.call(subway_data, source, destination, path_connections) }

      it 'result path is not empty' do
        expect(result_path).not_to be_empty
      end

      it 'result path has 3 segments' do
        expect(result_path.size).to eq(3)
      end

      it 'first segment in result path is from PARQUE DE LOS VENADOS to MIXCOAC in LINEA 12 with direction MIXCOAC' do
        expect(result_path.first[:source]).to eq("PARQUE DE LOS VENADOS")
        expect(result_path.first[:destination]).to eq("MIXCOAC")
        expect(result_path.first[:line]).to eq("LINEA 12")
        expect(result_path.first[:direction]).to eq("MIXCOAC")
      end

      it 'second segment in result path is from MIXCOAC to TACUBAYA in LINEA 7 with direction EL ROSARIO' do
        expect(result_path[1][:source]).to eq("MIXCOAC")
        expect(result_path[1][:destination]).to eq("TACUBAYA")
        expect(result_path[1][:line]).to eq("LINEA 7")
        expect(result_path[1][:direction]).to eq("EL ROSARIO")
      end

      it 'last segment in result path is from TACUBAYA to OBSERVATORIO in LINEA 1 with direction OBSERVATORIO' do
        expect(result_path.last[:source]).to eq("TACUBAYA")
        expect(result_path.last[:destination]).to eq("OBSERVATORIO")
        expect(result_path.last[:line]).to eq("LINEA 1")
        expect(result_path.last[:direction]).to eq("OBSERVATORIO")
      end
    end
  end

  describe 'call when destination is connection station' do
    context 'source line and destination line intersect' do
      let(:source) { "PORTALES" }
      let(:destination) { "SAN LAZARO" }
      let(:path_connections) { {
        source_line: "LINEA 2",
        connections: [ {line: "LINEA 1", station: "PINO SUAREZ"} ]
      } }
      let(:result_path) { SubwayEngine::ResultPathCreator.call(subway_data, source, destination, path_connections) }

      it 'result path is not empty' do
        expect(result_path).not_to be_empty
      end

      it 'result path has 2 segments' do
        expect(result_path.size).to eq(2)
      end

      it 'first segment in result path is from PORTALES to PINO SUAREZ in LINEA 2 with direction CUATRO CAMINOS' do
        expect(result_path.first[:source]).to eq("PORTALES")
        expect(result_path.first[:destination]).to eq("PINO SUAREZ")
        expect(result_path.first[:line]).to eq("LINEA 2")
        expect(result_path.first[:direction]).to eq("CUATRO CAMINOS")
      end

      it 'last segment in result path is from PINO SUAREZ to SAN LAZARO in LINEA 1 with direction PANTITLAN' do
        expect(result_path.last[:source]).to eq("PINO SUAREZ")
        expect(result_path.last[:destination]).to eq("SAN LAZARO")
        expect(result_path.last[:line]).to eq("LINEA 1")
        expect(result_path.last[:direction]).to eq("PANTITLAN")
      end
    end
  end
end