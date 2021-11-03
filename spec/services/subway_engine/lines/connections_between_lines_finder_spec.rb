require 'rails_helper'

RSpec.configure do |config|
  config.before(:all) do
    @subway_data = SubwayDescriptor.call
    SAME_LINE = "SAME_LINE"
    DIRECT_INTERSECT = "DIRECT_INTERSECT"
    THIRD_INTERSECT = "THIRD_INTERSECT"
  end
end

RSpec.describe SubwayEngine::Lines::ConnectionsBetweenLinesFinder, type: :model do
  describe 'call case same line' do
    context 'when source and destination lines has one item only' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 2"], ["LINEA 2"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = SAME_LINE' do
        expect(@result[:connection_type]).to eq(SAME_LINE)
      end

      it 'should returns source line, destination line and intersections are the same' do
        expect(@result[:source_line]).to eq(@result[:destination_line].first)
        expect(@result[:source_line]).to eq(@result[:intersections].first)
      end
    end

    context 'when source has one item only and destination lines has multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 2"], ["LINEA 2", "LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = SAME_LINE' do
        expect(@result[:connection_type]).to eq(SAME_LINE)
      end

      it 'should returns source line, destination line and intersections are the same' do
        expect(@result[:source_line]).to eq(@result[:destination_line].first)
        expect(@result[:source_line]).to eq(@result[:intersections].first)
      end
    end

    context 'when source has multiple lines and destination lines has one item only' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 2", "LINEA 12"], ["LINEA 2"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = SAME_LINE' do
        expect(@result[:connection_type]).to eq(SAME_LINE)
      end

      it 'should returns source line, destination line and intersections are the same' do
        expect(@result[:source_line]).to eq(@result[:destination_line].first)
        expect(@result[:source_line]).to eq(@result[:intersections].first)
      end
    end

    context 'when source and destination lines have multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 9", "LINEA 2", "LINEA 8"], ["LINEA 2", "LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = SAME_LINE' do
        expect(@result[:connection_type]).to eq(SAME_LINE)
      end

      it 'should returns source line, destination line and intersections are the same' do
        expect(@result[:source_line]).to eq(@result[:destination_line].first)
        expect(@result[:source_line]).to eq(@result[:intersections].first)
      end
    end
  end

  describe 'call case direct intersect' do
    context 'when source and destination lines has one item only' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 2"], ["LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = DIRECT_INTERSECT' do
        expect(@result[:connection_type]).to eq(DIRECT_INTERSECT)
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 2")
        expect(@result[:destination_line]).to eq(["LINEA 12"])
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq([{line: "LINEA 12", station: "ERMITA"}])
      end
    end

    context 'when source lines has one item only and destination lines has multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 12"], ["LINEA 2", "LINEA 8", "LINEA 9"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = DIRECT_INTERSECT' do
        expect(@result[:connection_type]).to eq(DIRECT_INTERSECT)
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 12")
        expect(@result[:destination_line]).to eq(["LINEA 2", "LINEA 8"])
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq([{line: "LINEA 2", station: "ERMITA"}, {line: "LINEA 8", station: "ATLALILCO"}])
      end
    end

    context 'when source lines has multiple lines and destination lines has one item only' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 1", "LINEA 7", "LINEA 9"], ["LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = DIRECT_INTERSECT' do
        expect(@result[:connection_type]).to eq(DIRECT_INTERSECT)
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 7")
        expect(@result[:destination_line]).to eq(["LINEA 12"])
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq([{line: "LINEA 12", station: "MIXCOAC"}])
      end
    end

    context 'when source and destination lines have multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 1", "LINEA 5", "LINEA 9", "LINEA A"], ["LINEA 2", "LINEA 7"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = DIRECT_INTERSECT' do
        expect(@result[:connection_type]).to eq(DIRECT_INTERSECT)
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 1")
        expect(@result[:destination_line]).to eq(["LINEA 2", "LINEA 7"])
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq([{line: "LINEA 2", station: "PINO SUAREZ"}, {line: "LINEA 7", station: "TACUBAYA"}])
      end
    end
  end

  describe 'call case third intersect' do
    context 'when source and destination lines has one item only' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA B"], ["LINEA 7"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = THIRD_INTERSECT' do
        expect(@result[:connection_type]).to eq(THIRD_INTERSECT)
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA B")
        expect(@result[:destination_line]).to eq("LINEA 7")
      end

      it 'should returns intersections source' do
        expect(@result[:intersections][:source]).to eq([{line: "LINEA 1", station: "SAN LAZARO"}])
      end

      it 'should returns intersections destination' do
        expect(@result[:intersections][:destination]).to eq([{line: "LINEA 1", station: "TACUBAYA"}])
      end
    end

    context 'when source lines has one item only and destination lines has multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 6"], ["LINEA 8", "LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = THIRD_INTERSECT' do
        expect(@result[:connection_type]).to eq(THIRD_INTERSECT)
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 6")
        expect(@result[:destination_line]).to eq("LINEA 8")
      end

      it 'should returns intersections source' do
        expect(@result[:intersections][:source]).to eq([{line: "LINEA 4", station: "MARTIN CARRERA"}])
      end

      it 'should returns intersections destination' do
        expect(@result[:intersections][:destination]).to eq([{line: "LINEA 4", station: "SANTA ANITA"}])
      end
    end

    context 'when source lines has multiple lines and destination lines has one item only' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 5", "LINEA B"], ["LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = THIRD_INTERSECT' do
        expect(@result[:connection_type]).to eq(THIRD_INTERSECT)
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 5")
        expect(@result[:destination_line]).to eq("LINEA 12")
      end

      it 'should returns intersections source' do
        expect(@result[:intersections][:source]).to eq([{line: "LINEA 3", station: "LA RAZA"}])
      end

      it 'should returns intersections destination' do
        expect(@result[:intersections][:destination]).to eq([{line: "LINEA 3", station: "ZAPATA"}])
      end
    end

    context 'when source lines and destination lines has multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 5", "LINEA B"], ["LINEA 2", "LINEA 7"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns result with connection type = THIRD_INTERSECT' do
        expect(@result[:connection_type]).to eq(THIRD_INTERSECT)
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 5")
        expect(@result[:destination_line]).to eq("LINEA 2")
      end

      it 'should returns intersections source' do
        expect(@result[:intersections][:source]).to eq([{line: "LINEA 1", station: "PANTITLAN"}, {line: "LINEA 3", station: "LA RAZA"}, {line: "LINEA 9", station: "PANTITLAN"}])
      end

      it 'should returns intersections destination' do
        expect(@result[:intersections][:destination]).to eq([{line: "LINEA 1", station: "PINO SUAREZ"}, {line: "LINEA 3", station: "HIDALGO"}, {line: "LINEA 9", station: "CHABACANO"}])
      end
    end
  end
end