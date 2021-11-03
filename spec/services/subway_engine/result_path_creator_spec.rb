require 'rails_helper'
RSpec.configure do |config|
  config.before(:all) do
    @subway_data = SubwayDescriptor.call
    SAME_LINE = "SAME_LINE"
    DIRECT_INTERSECT = "DIRECT_INTERSECT"
    THIRD_INTERSECT = "THIRD_INTERSECT"
  end
end

RSpec.describe SubwayEngine::ResultPathCreator, type: :model do
  describe 'call when source and destination are in the same line' do
    context 'source and destination are not connection stations' do
      before(:all) do
        @source = "PORTALES"
        @destination = "XOLA"
        @connections = {
          source_line: "LINEA 2",
          intersections: ["LINEA 2"],
          destination_line: ["LINEA 2"],
          connection_type: SAME_LINE
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @connections)
      end

      it 'returns result path with one segment only' do
        expect(@result_path.size).to eq(1)
      end

      it "returns the segment line is source line in connections" do
        expect(@result_path.first[:line]).to eq(@connections[:source_line])
      end

      it "returns the segment source is #{@source}" do
        expect(@result_path.first[:source]).to eq(@source)
      end

      it "returns the segment source is #{@destination}" do
        expect(@result_path.first[:destination]).to eq(@destination)
      end

      it "returns the segment direction is CUATRO CAMINOS" do
        expect(@result_path.first[:direction]).to eq("CUATRO CAMINOS")
      end

      it "returns the segment count stations is 3" do
        expect(@result_path.first[:count_stations]).to eq(3)
      end
    end

    context 'source is not connection station and destination is connection station' do
      before(:all) do
        @source = "PORTALES"
        @destination = "CHABACANO"
        @connections = {
          source_line: "LINEA 2",
          intersections: ["LINEA 2"],
          destination_line: ["LINEA 2"],
          connection_type: SAME_LINE
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @connections)
      end

      it 'returns result path with one segment only' do
        expect(@result_path.size).to eq(1)
      end

      it "returns the segment line is source line in connections" do
        expect(@result_path.first[:line]).to eq(@connections[:source_line])
      end

      it "returns the segment source is #{@source}" do
        expect(@result_path.first[:source]).to eq(@source)
      end

      it "returns the segment destination is #{@destination}" do
        expect(@result_path.first[:destination]).to eq(@destination)
      end

      it "returns the segment direction is CUATRO CAMINOS" do
        expect(@result_path.first[:direction]).to eq("CUATRO CAMINOS")
      end

      it "returns the segment count stations is 5" do
        expect(@result_path.first[:count_stations]).to eq(5)
      end
    end

    context 'source is connection station and destination is not connection station' do
      before(:all) do
        @source = "CHABACANO"
        @destination = "PORTALES"
        @connections = {
          source_line: "LINEA 2",
          intersections: ["LINEA 2"],
          destination_line: ["LINEA 2"],
          connection_type: SAME_LINE
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @connections)
      end

      it 'returns result path with one segment only' do
        expect(@result_path.size).to eq(1)
      end

      it "returns the segment line is source line in connections" do
        expect(@result_path.first[:line]).to eq(@connections[:source_line])
      end

      it "returns the segment source is #{@source}" do
        expect(@result_path.first[:source]).to eq(@source)
      end

      it "returns the segment destination is #{@destination}" do
        expect(@result_path.first[:destination]).to eq(@destination)
      end

      it "returns the segment direction is TASQUENA" do
        expect(@result_path.first[:direction]).to eq("TASQUENA")
      end

      it "returns the segment count stations is 5" do
        expect(@result_path.first[:count_stations]).to eq(5)
      end
    end

    context 'source and destination are connection stations' do
      before(:all) do
        @source = "CHABACANO"
        @destination = "ERMITA"
        @connections = {
          source_line: "LINEA 2",
          intersections: ["LINEA 2"],
          destination_line: ["LINEA 2"],
          connection_type: SAME_LINE
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @connections)
      end

      it 'returns result path with one segment only' do
        expect(@result_path.size).to eq(1)
      end

      it "returns the segment line is source line in connections" do
        expect(@result_path.first[:line]).to eq(@connections[:source_line])
      end

      it "returns the segment source is #{@source}" do
        expect(@result_path.first[:source]).to eq(@source)
      end

      it "returns the segment destination is #{@destination}" do
        expect(@result_path.first[:destination]).to eq(@destination)
      end

      it "returns the segment direction is TASQUENA" do
        expect(@result_path.first[:direction]).to eq("TASQUENA")
      end

      it "returns the segment count stations is 6" do
        expect(@result_path.first[:count_stations]).to eq(6)
      end
    end
  end

  describe 'call when source is in distinct line of destination, but they directly intersect' do
    context 'source and destination are not connection stations' do
      before(:all) do
        @source = "PORTALES"
        @destination = "PARQUE DE LOS VENADOS"
        @connections = {
          source_line: "LINEA 2",
          intersections: [{line: "LINEA 12", station: "ERMITA"}],
          destination_line: ["LINEA 12"],
          connection_type: DIRECT_INTERSECT
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @connections)
      end

      it 'returns result path with one segment only' do
        expect(@result_path.size).to eq(2)
      end

      it "returns the first segment line is source line in connections" do
        expect(@result_path.first[:line]).to eq(@connections[:source_line])
      end

      it "returns the first segment source is #{@source}" do
        expect(@result_path.first[:source]).to eq(@source)
      end

      it "returns the first segment destination is ERMITA" do
        expect(@result_path.first[:destination]).to eq("ERMITA")
      end

      it "returns the first segment direction is TASQUENA" do
        expect(@result_path.first[:direction]).to eq("TASQUENA")
      end

      it "returns the first segment count stations is 1" do
        expect(@result_path.first[:count_stations]).to eq(1)
      end

      it "returns the last segment line is source line in connections" do
        expect(@result_path.last[:line]).to eq(@connections[:destination_line].first)
      end

      it "returns the last segment source is ERMITA" do
        expect(@result_path.last[:source]).to eq("ERMITA")
      end

      it "returns the last segment destination is #{@destination}" do
        expect(@result_path.last[:destination]).to eq(@destination)
      end

      it "returns the last segment direction is MIXCOAC" do
        expect(@result_path.last[:direction]).to eq("MIXCOAC")
      end

      it "returns the last segment count stations is 2" do
        expect(@result_path.last[:count_stations]).to eq(2)
      end
    end

    context 'source is not connection station and destination is connection station' do
      before(:all) do
        @source = "PORTALES"
        @destination = "BALDERAS"
        @connections = {
          source_line: "LINEA 2",
          intersections: [{line: "LINEA 1", station: "PINO SUAREZ"}],
          destination_line: ["LINEA 1"],
          connection_type: DIRECT_INTERSECT
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @connections)
      end

      it 'returns result path with one segment only' do
        expect(@result_path.size).to eq(2)
      end

      it "returns the first segment line is source line in connections" do
        expect(@result_path.first[:line]).to eq(@connections[:source_line])
      end

      it "returns the first segment source is #{@source}" do
        expect(@result_path.first[:source]).to eq(@source)
      end

      it "returns the first segment destination is PINO SUAREZ" do
        expect(@result_path.first[:destination]).to eq("PINO SUAREZ")
      end

      it "returns the first segment direction is CUATRO CAMINOS" do
        expect(@result_path.first[:direction]).to eq("CUATRO CAMINOS")
      end

      it "returns the first segment count stations is 7" do
        expect(@result_path.first[:count_stations]).to eq(7)
      end

      it "returns the last segment line is source line in connections" do
        expect(@result_path.last[:line]).to eq(@connections[:destination_line].first)
      end

      it "returns the last segment source is PINO SUAREZ" do
        expect(@result_path.last[:source]).to eq("PINO SUAREZ")
      end

      it "returns the last segment destination is #{@destination}" do
        expect(@result_path.last[:destination]).to eq(@destination)
      end

      it "returns the last segment direction is OBSERVATORIO" do
        expect(@result_path.last[:direction]).to eq("OBSERVATORIO")
      end

      it "returns the last segment count stations is 3" do
        expect(@result_path.last[:count_stations]).to eq(3)
      end
    end

    context 'source is connection station and destination is not connection station' do
      before(:all) do
        @source = "DEPORTIVO 18 DE MARZO"
        @destination = "TEPITO"
        @connections = {
          source_line: "LINEA 3",
          intersections: [{line: "LINEA B", station: "GUERRERO"}],
          destination_line: ["LINEA B"],
          connection_type: DIRECT_INTERSECT
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @connections)
      end

      it 'returns result path with one segment only' do
        expect(@result_path.size).to eq(2)
      end

      it "returns the first segment line is source line in connections" do
        expect(@result_path.first[:line]).to eq(@connections[:source_line])
      end

      it "returns the first segment source is #{@source}" do
        expect(@result_path.first[:source]).to eq(@source)
      end

      it "returns the first segment destination is GUERRERO" do
        expect(@result_path.first[:destination]).to eq("GUERRERO")
      end

      it "returns the first segment direction is UNIVERSIDAD" do
        expect(@result_path.first[:direction]).to eq("UNIVERSIDAD")
      end

      it "returns the first segment count stations is 4" do
        expect(@result_path.first[:count_stations]).to eq(4)
      end

      it "returns the last segment line is source line in connections" do
        expect(@result_path.last[:line]).to eq(@connections[:destination_line].first)
      end

      it "returns the last segment source is GUERRERO" do
        expect(@result_path.last[:source]).to eq("GUERRERO")
      end

      it "returns the last segment destination is #{@destination}" do
        expect(@result_path.last[:destination]).to eq(@destination)
      end

      it "returns the last segment direction is CIUDAD AZTECA" do
        expect(@result_path.last[:direction]).to eq("CIUDAD AZTECA")
      end

      it "returns the last segment count stations is 3" do
        expect(@result_path.last[:count_stations]).to eq(3)
      end
    end

    context 'source and destination are connection stations' do
      before(:all) do
        @source = "PANTITLAN"
        @destination = "TACUBA"
        @connections = {
          source_line: "LINEA 1",
          intersections: [{:line=>"LINEA 2", :station=>"PINO SUAREZ"}, {:line=>"LINEA 7", :station=>"TACUBAYA"}],
          destination_line: ["LINEA 2", "LINEA 7"],
          connection_type: DIRECT_INTERSECT
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @connections)
      end

      it 'returns result path with one segment only' do
        expect(@result_path.size).to eq(2)
      end

      it "returns the first segment line is source line in connections" do
        expect(@result_path.first[:line]).to eq(@connections[:source_line])
      end

      it "returns the first segment source is #{@source}" do
        expect(@result_path.first[:source]).to eq(@source)
      end

      it "returns the first segment destination is PINO SUAREZ" do
        expect(@result_path.first[:destination]).to eq("PINO SUAREZ")
      end

      it "returns the first segment direction is OBSERVATORIO" do
        expect(@result_path.first[:direction]).to eq("OBSERVATORIO")
      end

      it "returns the first segment count stations is 9" do
        expect(@result_path.first[:count_stations]).to eq(9)
      end

      it "returns the last segment line is source line in connections" do
        expect(@result_path.last[:line]).to eq(@connections[:destination_line].first)
      end

      it "returns the last segment source is PINO SUAREZ" do
        expect(@result_path.last[:source]).to eq("PINO SUAREZ")
      end

      it "returns the last segment destination is #{@destination}" do
        expect(@result_path.last[:destination]).to eq(@destination)
      end

      it "returns the last segment direction is CUATRO CAMINOS" do
        expect(@result_path.last[:direction]).to eq("CUATRO CAMINOS")
      end

      it "returns the last segment count stations is 11" do
        expect(@result_path.last[:count_stations]).to eq(11)
      end
    end
  end

  describe 'call when source is in distinct line of destination, and they intersected through a third line' do
    context 'source and destination are not connection stations' do
      before(:all) do
        @source = "BOSQUE DE ARAGON"
        @destination = "REFINERIA"
        @connections = {
          source_line: "LINEA B",
          intersections: {:source=>[{:line=>"LINEA 1", :station=>"SAN LAZARO"}], :destination=>[{:line=>"LINEA 1", :station=>"TACUBAYA"}]},
          destination_line: "LINEA 7",
          connection_type: THIRD_INTERSECT
        }
        @result_path = SubwayEngine::ResultPathCreator.call(@subway_data, @source, @destination, @connections)
      end

      it 'returns result path with one segment only' do
        expect(@result_path.size).to eq(3)
      end

      it "returns the first segment line is source line in connections" do
        expect(@result_path.first[:line]).to eq(@connections[:source_line])
      end

      it "returns the first segment source is #{@source}" do
        expect(@result_path.first[:source]).to eq(@source)
      end

      it "returns the first segment destination is SAN LAZARO" do
        expect(@result_path.first[:destination]).to eq("SAN LAZARO")
      end

      it "returns the first segment direction is BUENAVISTA" do
        expect(@result_path.first[:direction]).to eq("BUENAVISTA")
      end

      it "returns the first segment count stations is 5" do
        expect(@result_path.first[:count_stations]).to eq(5)
      end

      it "returns the second segment line is LINEA 1" do
        expect(@result_path[1][:line]).to eq("LINEA 1")
      end

      it "returns the second segment source is SAN LAZARO" do
        expect(@result_path[1][:source]).to eq("SAN LAZARO")
      end

      it "returns the second segment destination is TACUBAYA" do
        expect(@result_path[1][:destination]).to eq("TACUBAYA")
      end

      it "returns the second segment direction is OBSERVATORIO" do
        expect(@result_path[1][:direction]).to eq("OBSERVATORIO")
      end

      it "returns the second segment count stations is 12" do
        expect(@result_path[1][:count_stations]).to eq(12)
      end

      it "returns the last segment line is source line in connections" do
        expect(@result_path.last[:line]).to eq(@connections[:destination_line])
      end

      it "returns the last segment source is TACUBAYA" do
        expect(@result_path.last[:source]).to eq("TACUBAYA")
      end

      it "returns the last segment destination is #{@destination}" do
        expect(@result_path.last[:destination]).to eq(@destination)
      end

      it "returns the last segment direction is EL ROSARIO" do
        expect(@result_path.last[:direction]).to eq("EL ROSARIO")
      end

      it "returns the last segment count stations is 6" do
        expect(@result_path.last[:count_stations]).to eq(6)
      end
    end
  end
end