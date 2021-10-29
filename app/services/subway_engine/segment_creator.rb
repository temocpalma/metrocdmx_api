module SubwayEngine
  class SegmentCreator < ApplicationService
    def initialize(subway_data, line, source, destination)
      @subway_data = subway_data
      @line = line
      @source = source
      @destination = destination
    end

    def call
      line_data = Lines::LineByNameFinder.call(@subway_data, @line)
      return {} unless stations_are_in_line(line_data)
      {
        line: @line,
        source: @source,
        destination: @destination,
        direction: Stations::DirectionBetweenStationsInLine.call(@subway_data, @line, @source, @destination),
        count_stations: Stations::CountBetweenStationsCalculator.call(line_data, @source, @destination)
      }
    end

    private

    def stations_are_in_line(line)
      Stations::StationIsInLineValidator.call(@source, line) && Stations::StationIsInLineValidator.call(@destination, line)
    end

  end
end