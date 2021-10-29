require 'rails_helper'
RSpec.configure do |config|
  config.before(:all) do
    @subway_data = SubwayDescriptor.call
  end
end

RSpec.describe SubwayEngine::PathCalculator, type: :model do

  describe 'call' do
    context 'when source and destination are in the same line' do
      before(:all) do
        @result = SubwayEngine::PathCalculator.call(@subway_data, "PORTALES", "XOLA")
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path list with a segment only' do
        expect(@result.size).to eq(1)
      end

      it 'returns the segment with line 2' do
        expect(@result.first[:line]).to eq("LINEA 2")
      end

      it 'returns the segment with direction to CUATRO CAMINOS' do
        expect(@result.first[:direction]).to eq("CUATRO CAMINOS")
      end
    end

    context 'when source = ZAPATA and destination = BALDERAS are in the same line' do
      before(:all) do
        @result = SubwayEngine::PathCalculator.call(@subway_data, "ZAPATA", "BALDERAS")
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path list with a segment only' do
        expect(@result.size).to eq(1)
      end

      it 'returns the segment with line 3' do
        expect(@result.first[:line]).to eq("LINEA 3")
      end

      it 'returns the segment with direction to INDIOS VERDES' do
        expect(@result.first[:direction]).to eq("INDIOS VERDES")
      end
    end
  end

  describe 'call when source and destination are in distincts lines, which intersect' do

    context 'sample PORTALES to PARQUE DE LOS VENADOS' do
      before(:all) do
        @result = SubwayEngine::PathCalculator.call(@subway_data, "PORTALES", "PARQUE DE LOS VENADOS")
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path list with two segments' do
        expect(@result.size).to eq(2)
      end

      it 'returns the first segment with LINEA 2, source PORTALES, destination ERMITA, direction TASQUENA' do
        expect(@result.first[:line]).to eq("LINEA 2")
        expect(@result.first[:source]).to eq("PORTALES")
        expect(@result.first[:destination]).to eq("ERMITA")
        expect(@result.first[:direction]).to eq("TASQUENA")
        expect(@result.first[:count_stations]).to eq(1)
      end

      it 'returns the last segment with LINEA 12, source ERMITA, destination PARQUE DE LOS VENADOS, direction MIXCOAC' do
        expect(@result.last[:line]).to eq("LINEA 12")
        expect(@result.last[:source]).to eq("ERMITA")
        expect(@result.last[:destination]).to eq("PARQUE DE LOS VENADOS")
        expect(@result.last[:direction]).to eq("MIXCOAC")
        expect(@result.last[:count_stations]).to eq(2)
      end
    end

    context 'sample TEZOZOMOC to LA RAZA' do
      before(:all) do
        @result = SubwayEngine::PathCalculator.call(@subway_data, "TEZOZOMOC", "LA RAZA")
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path list with two segments' do
        expect(@result.size).to eq(2)
      end

      it 'returns the first segment with LINEA 6, source TEZOZOMOC, destination INSTITUTO DEL PETROLEO, direction MARTIN CARRERA' do
        expect(@result.first[:line]).to eq("LINEA 6")
        expect(@result.first[:source]).to eq("TEZOZOMOC")
        expect(@result.first[:destination]).to eq("INSTITUTO DEL PETROLEO")
        expect(@result.first[:direction]).to eq("MARTIN CARRERA")
        expect(@result.first[:count_stations]).to eq(5)
      end

      it 'returns the last segment with LINEA 5, source INSTITUTO DEL PETROLEO, destination LA RAZA, direction PANTITLAN' do
        expect(@result.last[:line]).to eq("LINEA 5")
        expect(@result.last[:source]).to eq("INSTITUTO DEL PETROLEO")
        expect(@result.last[:destination]).to eq("LA RAZA")
        expect(@result.last[:direction]).to eq("PANTITLAN")
        expect(@result.last[:count_stations]).to eq(2)
      end
    end
  end

  describe 'call when source and destination connected throuhg a third line' do

    context 'sample PARQUE DE LOS VENADOS to OBSERVATORIO' do
      before(:all) do
        @result = SubwayEngine::PathCalculator.call(@subway_data, "PARQUE DE LOS VENADOS", "OBSERVATORIO")
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path list with two segments' do
        expect(@result.size).to eq(3)
      end

      it 'returns the first segment with LINEA 12, source PARQUE DE LOS VENADOS, destination MIXCOAC, direction MIXCOAC' do
        expect(@result.first[:line]).to eq("LINEA 12")
        expect(@result.first[:source]).to eq("PARQUE DE LOS VENADOS")
        expect(@result.first[:destination]).to eq("MIXCOAC")
        expect(@result.first[:direction]).to eq("MIXCOAC")
        expect(@result.first[:count_stations]).to eq(4)
      end

      it 'returns the second segment with LINEA 7, source MIXCOAC, destination TACUBAYA, direction EL ROSARIO' do
        expect(@result[1][:line]).to eq("LINEA 7")
        expect(@result[1][:source]).to eq("MIXCOAC")
        expect(@result[1][:destination]).to eq("TACUBAYA")
        expect(@result[1][:direction]).to eq("EL ROSARIO")
        expect(@result[1][:count_stations]).to eq(3)
      end

      it 'returns the last segment with LINEA 1, source TACUBAYA, destination OBSERVATORIO, direction OBSERVATORIO' do
        expect(@result.last[:line]).to eq("LINEA 1")
        expect(@result.last[:source]).to eq("TACUBAYA")
        expect(@result.last[:destination]).to eq("OBSERVATORIO")
        expect(@result.last[:direction]).to eq("OBSERVATORIO")
        expect(@result.last[:count_stations]).to eq(1)
      end
    end

    context 'sample PORTALES to TEZOZOMOC' do
      before(:all) do
        @result = SubwayEngine::PathCalculator.call(@subway_data, "PORTALES", "TEZOZOMOC")
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path list with two segments' do
        expect(@result.size).to eq(3)
      end

      it 'returns the first segment with LINEA 2, source PORTALES, destination TACUBA, direction CUATRO CAMINOS' do
        expect(@result.first[:line]).to eq("LINEA 2")
        expect(@result.first[:source]).to eq("PORTALES")
        expect(@result.first[:destination]).to eq("TACUBA")
        expect(@result.first[:direction]).to eq("CUATRO CAMINOS")
        expect(@result.first[:count_stations]).to eq(18)
      end

      it 'returns the second segment with LINEA 7, source TACUBA, destination EL ROSARIO, direction EL ROSARIO' do
        expect(@result[1][:line]).to eq("LINEA 7")
        expect(@result[1][:source]).to eq("TACUBA")
        expect(@result[1][:destination]).to eq("EL ROSARIO")
        expect(@result[1][:direction]).to eq("EL ROSARIO")
        expect(@result[1][:count_stations]).to eq(4)
      end

      it 'returns the last segment with LINEA 6, source EL ROSARIO, destination TEZOZOMOC, direction MARTIN CARRERA' do
        expect(@result.last[:line]).to eq("LINEA 6")
        expect(@result.last[:source]).to eq("EL ROSARIO")
        expect(@result.last[:destination]).to eq("TEZOZOMOC")
        expect(@result.last[:direction]).to eq("MARTIN CARRERA")
        expect(@result.last[:count_stations]).to eq(1)
      end
    end

    context 'sample EL ROSARIO to COYUYA' do
      before(:all) do
        @result = SubwayEngine::PathCalculator.call(@subway_data, "EL ROSARIO", "COYUYA")
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path list with two segments' do
        expect(@result.size).to eq(3)
      end

      it 'returns the first segment with LINEA 6, source EL ROSARIO, destination MARTIN CARRERA, direction MARTIN CARRERA' do
        expect(@result.first[:line]).to eq("LINEA 6")
        expect(@result.first[:source]).to eq("EL ROSARIO")
        expect(@result.first[:destination]).to eq("MARTIN CARRERA")
        expect(@result.first[:direction]).to eq("MARTIN CARRERA")
        expect(@result.first[:count_stations]).to eq(10)
      end

      it 'returns the second segment with LINEA 4, source MARTIN CARRERA, destination SANTA ANITA, direction SANTA ANITA' do
        expect(@result[1][:line]).to eq("LINEA 4")
        expect(@result[1][:source]).to eq("MARTIN CARRERA")
        expect(@result[1][:destination]).to eq("SANTA ANITA")
        expect(@result[1][:direction]).to eq("SANTA ANITA")
        expect(@result[1][:count_stations]).to eq(9)
      end

      it 'returns the last segment with LINEA 8, source SANTA ANITA, destination COYUYA, direction CONSTITUCION DE 1917' do
        expect(@result.last[:line]).to eq("LINEA 8")
        expect(@result.last[:source]).to eq("SANTA ANITA")
        expect(@result.last[:destination]).to eq("COYUYA")
        expect(@result.last[:direction]).to eq("CONSTITUCION DE 1917")
        expect(@result.last[:count_stations]).to eq(1)
      end
    end

    context 'sample MIXCOAC to OCEANIA' do
      before(:all) do
        @result = SubwayEngine::PathCalculator.call(@subway_data, "MIXCOAC", "OCEANIA")
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path list with two segments' do
        expect(@result.size).to eq(3)
      end

      it 'returns the first segment with LINEA 7, source MIXCOAC, destination TACUBAYA, direction EL ROSARIO' do
        expect(@result.first[:line]).to eq("LINEA 7")
        expect(@result.first[:source]).to eq("MIXCOAC")
        expect(@result.first[:destination]).to eq("TACUBAYA")
        expect(@result.first[:direction]).to eq("EL ROSARIO")
        expect(@result.first[:count_stations]).to eq(3)
      end

      it 'returns the second segment with LINEA 1, source TACUBAYA, destination PANTITLAN, direction PANTITLAN' do
        expect(@result[1][:line]).to eq("LINEA 1")
        expect(@result[1][:source]).to eq("TACUBAYA")
        expect(@result[1][:destination]).to eq("PANTITLAN")
        expect(@result[1][:direction]).to eq("PANTITLAN")
        expect(@result[1][:count_stations]).to eq(18)
      end

      it 'returns the last segment with LINEA 5, source PANTITLAN, destination OCEANIA, direction POLITECNICO' do
        expect(@result.last[:line]).to eq("LINEA 5")
        expect(@result.last[:source]).to eq("PANTITLAN")
        expect(@result.last[:destination]).to eq("OCEANIA")
        expect(@result.last[:direction]).to eq("POLITECNICO")
        expect(@result.last[:count_stations]).to eq(3)
      end
    end
  end
end