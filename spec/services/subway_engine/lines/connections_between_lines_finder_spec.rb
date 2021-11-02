require 'rails_helper'

RSpec.configure do |config|
  config.before(:all) do
    @subway_data = SubwayDescriptor.call
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

      it 'should returns source line, destination line and intersections are the same' do
        expect(@result[:source_line]).to eq(@result[:destination_line])
        expect(@result[:source_line]).to eq(@result[:intersections])
      end
    end

    context 'when source has one item only and destination lines has multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 2"], ["LINEA 2", "LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns source line, destination line and intersections are the same' do
        expect(@result[:source_line]).to eq(@result[:destination_line])
        expect(@result[:source_line]).to eq(@result[:intersections])
      end
    end

    context 'when source has multiple lines and destination lines has one item only' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 2", "LINEA 12"], ["LINEA 2"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns source line, destination line and intersections are the same' do
        expect(@result[:source_line]).to eq(@result[:destination_line])
        expect(@result[:source_line]).to eq(@result[:intersections])
      end
    end

    context 'when source and destination lines have multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 9", "LINEA 2", "LINEA 8"], ["LINEA 2", "LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns source line, destination line and intersections are the same' do
        expect(@result[:source_line]).to eq(@result[:destination_line])
        expect(@result[:source_line]).to eq(@result[:intersections])
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

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 2")
        expect(@result[:destination_line]).to eq(["LINEA 12"])
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq(["LINEA 12"])
      end
    end

    context 'when source lines has one item only and destination lines has multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 12"], ["LINEA 2", "LINEA 8", "LINEA 9"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 12")
        expect(@result[:destination_line]).to eq(["LINEA 2", "LINEA 8"])
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq(["LINEA 2", "LINEA 8"])
      end
    end

    context 'when source lines has multiple lines and destination lines has one item only' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 1", "LINEA 7", "LINEA 9"], ["LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 7")
        expect(@result[:destination_line]).to eq(["LINEA 12"])
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq(["LINEA 12"])
      end
    end

    context 'when source and destination lines have multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 1", "LINEA 7", "LINEA 9"], ["LINEA 8", "LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 1")
        expect(@result[:destination_line]).to eq(["LINEA 8"])
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq(["LINEA 8"])
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

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA B")
        expect(@result[:destination_line]).to eq("LINEA 7")
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq(["LINEA 1"])
      end
    end

    context 'when source lines has one item only and destination lines has multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 6"], ["LINEA 8", "LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 6")
        expect(@result[:destination_line]).to eq("LINEA 8")
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq(["LINEA 4"])
      end
    end

    context 'when source lines has multiple lines and destination lines has one item only' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 5", "LINEA B"], ["LINEA 12"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 5")
        expect(@result[:destination_line]).to eq("LINEA 12")
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq(["LINEA 3"])
      end
    end

    context 'when source lines and destination lines has multiple lines' do
      before(:all) do
        @result = SubwayEngine::Lines::ConnectionsBetweenLinesFinder.call(@subway_data, ["LINEA 5", "LINEA B"], ["LINEA 2", "LINEA 7"])
      end

      it 'should returns result not empty' do
        expect(@result).not_to be_empty
      end

      it 'should returns source line, destination line' do
        expect(@result[:source_line]).to eq("LINEA 5")
        expect(@result[:destination_line]).to eq("LINEA 2")
      end

      it 'should returns intersections' do
        expect(@result[:intersections]).to eq(["LINEA 1", "LINEA 3", "LINEA 9"])
      end
    end
  end
end