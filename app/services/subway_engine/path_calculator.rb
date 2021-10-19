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

      unless intersection_lines.empty?
        [
          {
            line: intersection_lines.first,
            source: @source,
            destination: @destination,
            direction: DirectionBetweenStationsInLine.call(@subway_data, intersection_lines.first, @source, @destination)
          }
        ]
      end
    end

  end
end