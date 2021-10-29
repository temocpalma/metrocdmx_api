require 'rails_helper'
RSpec.configure do |config|
  config.before(:all) do
    @subway_data = SubwayDescriptor.call
  end
end

RSpec.describe SubwayEngine::PathConnectionsFinder, type: :model do
  describe 'call when source and destination lines have one line only' do
    context 'and they intersect' do
      before(:all) do
        @source = "PORTALES"
        @source_lines = ["LINEA 2"]
        @destination_lines = ["LINEA 12"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(@result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(@result[:source_line]).to eq("LINEA 2")
        expect(@result[:connections].first).to eq({line: "LINEA 12", station: "ERMITA", count_stations: 1})
      end
    end

    context 'and they do not intersect' do
      before(:all) do
        @source = "PORTALES"
        @source_lines = ["LINEA 2"]
        @destination_lines = ["LINEA 5"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).to be_empty
      end
    end
  end

  describe 'call when there are several source lines and destination lines has one line only' do

    context 'and they intersect through the first source line only' do
      before(:all) do
        @source = "ERMITA"
        @source_lines = ["LINEA 2", "LINEA 12"]
        @destination_lines = ["LINEA 9"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(@result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(@result[:source_line]).to eq("LINEA 2")
        expect(@result[:connections].first).to eq({line: "LINEA 9", station: "CHABACANO", count_stations: 6})
      end
    end

    context 'and they intersect through the second source line only' do
      before(:all) do
        @source = "TACUBA"
        @source_lines = ["LINEA 2", "LINEA 7"]
        @destination_lines = ["LINEA 6"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(@result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(@result[:source_line]).to eq("LINEA 7")
        expect(@result[:connections].first).to eq({line: "LINEA 6", station: "EL ROSARIO", count_stations: 4})
      end
    end

    context 'and they do not intersect' do
      before(:all) do
        @source = "TACUBA"
        @source_lines = ["LINEA 2", "LINEA 7"]
        @destination_lines = ["LINEA 5"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).to be_empty
      end
    end
  end

  describe 'call when there are several source lines and destination lines' do

    context 'and they intersect through first source line only with one destination line only' do
      before(:all) do
        @source = "ERMITA"
        @source_lines = ["LINEA 2", "LINEA 12"]
        @destination_lines = ["LINEA 4", "LINEA 9"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(@result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(@result[:source_line]).to eq("LINEA 2")
        expect(@result[:connections].first).to eq({line: "LINEA 9", station: "CHABACANO", count_stations: 6})
      end
    end

    context 'and they intersect through first source line only, with all destination lines' do
      before(:all) do
        @source = "ERMITA"
        @source_lines = ["LINEA 2", "LINEA 12"]
        @destination_lines = ["LINEA 3", "LINEA 9"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(@result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(@result[:source_line]).to eq("LINEA 2")
        expect(@result[:connections].first).to eq({line: "LINEA 9", station: "CHABACANO", count_stations: 6})
      end
    end

    context 'and they intersected through the second source line only, with one destination line only' do
      before(:all) do
        @source = "HIDALGO"
        @source_lines = ["LINEA 2", "LINEA 3"]
        @destination_lines = ["LINEA 4", "LINEA 6"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(@result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(@result[:source_line]).to eq("LINEA 3")
        expect(@result[:connections].first).to eq({line: "LINEA 6", station: "DEPORTIVO 18 DE MARZO", count_stations: 5})
      end
    end

    context 'and they intersect through of the second source line only, with all destination lines' do
      before(:all) do
        @source = "HIDALGO"
        @source_lines = ["LINEA 2", "LINEA 3"]
        @destination_lines = ["LINEA 5", "LINEA 6"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(@result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(@result[:source_line]).to eq("LINEA 3")
        expect(@result[:connections].first).to eq({line: "LINEA 5", station: "LA RAZA", count_stations: 3})
      end
    end

    context 'and they do not intersect' do
      before(:all) do
        @source = "MARTIN CARRERA"
        @source_lines = ["LINEA 4", "LINEA 6"]
        @destination_lines = ["LINEA 2", "LINEA 12"]
        @result = SubwayEngine::PathConnectionsFinder.call(@subway_data, @source, @source_lines, @destination_lines)
      end

      it 'returns the path list is not empty' do
        expect(@result).to be_empty
      end
    end
  end
end