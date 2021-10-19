module SubwayEngine
  class PathCalculator < ApplicationService
    def initialize(subway_data, source, destination)
      @subway_data = subway_data
      @source = source
      @destination = destination
    end

    def call
      compute_path
    end

    private

    def compute_path
      source_lines = LinesByStationFinder.call(@subway_data, @source)
      destination_lines = LinesByStationFinder.call(@subway_data, @destination)
      intersection_lines = source_lines & destination_lines

      return [ create_segment(intersection_lines.first, @source, @destination) ] unless intersection_lines.empty?


    end

    def create_segment(line, source, destination)
      {
        line: line,
        source: source,
        destination: destination,
        direction: DirectionBetweenStationsInLine.call(@subway_data, line, source, destination)
      }
    end

  end
end