require 'rails_helper'

RSpec.describe SubwayEngine::PathConnectionsFinder, type: :model do
  let(:subway_data) { SubwayDescriptor.call }
  describe 'call when source and destination lines have one line only' do
    context 'and they intersect' do
      let(:source_lines) { ["LINEA 2"] }
      let(:destination_lines) { ["LINEA 12"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(result[:source_line]).to eq("LINEA 2")
        expect(result[:connections].first).to eq({line: "LINEA 12", station: "ERMITA"})
      end
    end

    context 'and they do not intersect' do
      let(:source_lines) { ["LINEA 2"] }
      let(:destination_lines) { ["LINEA 5"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).to be_empty
      end
    end
  end

  describe 'call when there are several source lines and destination lines has one line only' do

    context 'and they intersect through first source line only' do
      let(:source_lines) { ["LINEA 2", "LINEA 12"] }
      let(:destination_lines) { ["LINEA 9"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(result[:source_line]).to eq("LINEA 2")
        expect(result[:connections].first).to eq({line: "LINEA 9", station: "CHABACANO"})
      end
    end

    context 'and they intersect through second source line only' do
      let(:source_lines) { ["LINEA 2", "LINEA 7"] }
      let(:destination_lines) { ["LINEA 6"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(result[:source_line]).to eq("LINEA 7")
        expect(result[:connections].first).to eq({line: "LINEA 6", station: "EL ROSARIO"})
      end
    end

    context 'and they do not intersect' do
      let(:source_lines) { ["LINEA 2", "LINEA 7"] }
      let(:destination_lines) { ["LINEA 5"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).to be_empty
      end
    end
  end

  describe 'call when there are several source lines and destination lines' do

    context 'and they intersect through first source line only with one destination line only' do
      let(:source_lines) { ["LINEA 2", "LINEA 12"] }
      let(:destination_lines) { ["LINEA 4", "LINEA 9"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(result[:source_line]).to eq("LINEA 2")
        expect(result[:connections].first).to eq({line: "LINEA 9", station: "CHABACANO"})
      end
    end

    context 'and they intersect through first source line only with all destination lines' do
      let(:source_lines) { ["LINEA 2", "LINEA 12"] }
      let(:destination_lines) { ["LINEA 3", "LINEA 9"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(result[:connections].size).to eq(2)
      end

      it 'returns the details connection' do
        expect(result[:source_line]).to eq("LINEA 2")
        expect(result[:connections].first).to eq({line: "LINEA 3", station: "HIDALGO"})
        expect(result[:connections].last).to eq({line: "LINEA 9", station: "CHABACANO"})
      end
    end

    context 'and they intersect through second line only with one destination line only' do
      let(:source_lines) { ["LINEA 2", "LINEA 3"] }
      let(:destination_lines) { ["LINEA 4", "LINEA 6"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(result[:connections].size).to eq(1)
      end

      it 'returns the details connection' do
        expect(result[:source_line]).to eq("LINEA 3")
        expect(result[:connections].first).to eq({line: "LINEA 6", station: "DEPORTIVO 18 DE MARZO"})
      end
    end

    context 'and they intersect through second line only with all destination lines' do
      let(:source_lines) { ["LINEA 2", "LINEA 3"] }
      let(:destination_lines) { ["LINEA 5", "LINEA 6"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).not_to be_empty
      end

      it 'returns the path connections with one element only' do
        expect(result[:connections].size).to eq(2)
      end

      it 'returns the details connection' do
        expect(result[:source_line]).to eq("LINEA 3")
        expect(result[:connections].first).to eq({line: "LINEA 5", station: "LA RAZA"})
        expect(result[:connections].last).to eq({line: "LINEA 6", station: "DEPORTIVO 18 DE MARZO"})
      end
    end

    context 'and they do not intersect' do
      let(:source_lines) { ["LINEA 4", "LINEA 6"] }
      let(:destination_lines) { ["LINEA 2", "LINEA 12"] }
      let(:result) { SubwayEngine::PathConnectionsFinder.call(subway_data, source_lines, destination_lines)}

      it 'returns the path list is not empty' do
        expect(result).to be_empty
      end
    end
  end
end