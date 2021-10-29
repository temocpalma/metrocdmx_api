require 'rails_helper'
RSpec.configure do |config|
  config.before(:all) do
    @subway_data = SubwayDescriptor.call
  end
end

RSpec.describe SubwayEngine::SegmentCreator, type: :model do
  describe 'call' do
    context 'when stations are in line' do
      before(:all) do
        @line = "LINEA 2"
        @source = "PORTALES"
        @destination = "PINO SUAREZ"
        @segment = SubwayEngine::SegmentCreator.call(@subway_data, @line, @source, @destination)
      end

      it 'should return a not empty segment' do
        expect(@segment).not_to be_empty
      end

      it 'segment detail contains direction to CUATRO CAMINOS' do
        expect(@segment[:direction]).to eq("CUATRO CAMINOS")
      end

      it 'segment detail contains count stations equals to 7' do
        expect(@segment[:count_stations]).to eq(7)
      end
    end

    context 'when source is not in line' do
      before(:all) do
        @line = "LINEA 2"
        @source = "ZAPATA"
        @destination = "PINO SUAREZ"
        @segment = SubwayEngine::SegmentCreator.call(@subway_data, @line, @source, @destination)
      end

      it 'should return a empty segment' do
        expect(@segment).to be_empty
      end
    end

    context 'when destination is not in line' do
      before(:all) do
        @line = "LINEA 2"
        @source = "PORTALES"
        @destination = "CENTRO MEDICO"
        @segment = SubwayEngine::SegmentCreator.call(@subway_data, @line, @source, @destination)
      end

      it 'should return a empty segment' do
        expect(@segment).to be_empty
      end
    end

    context 'when source and destination are not in line' do
      before(:all) do
        @line = "LINEA 2"
        @source = "ZAPATA"
        @destination = "CENTRO MEDICO"
        @segment = SubwayEngine::SegmentCreator.call(@subway_data, @line, @source, @destination)
      end

      it 'should return a empty segment' do
        expect(@segment).to be_empty
      end
    end
  end
end