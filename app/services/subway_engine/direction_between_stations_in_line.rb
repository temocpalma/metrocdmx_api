module SubwayEngine
  class DirectionBetweenStationsInLine < ApplicationService
    def initialize(subway_data, line, source, destination)
      @subway_data = subway_data
      @line = line
      @source = source
      @destination = destination
    end

    def call
      direction
    end

    private

    def direction
      line = Lines::LineByNameFinder.call(@subway_data, @line)
      source_pos = Stations::StationPositionInLineFinder.call(line, @source)
      destination_pos = Stations::StationPositionInLineFinder.call(line, @destination)

      return "#{@source} does not exists in #{@line}" if source_pos.nil?
      return "#{@destination} does not exists in #{@line}" if destination_pos.nil?
      return "Source and Destination is the same" if source_pos == destination_pos
      return line[:stations].last[:name] if source_pos < destination_pos
      line[:stations].first[:name] if source_pos > destination_pos
    end

  end
end