module SubwayEngine
  class ResultPathCreator < ApplicationService
    def initialize(subway_data, source, destination, path_connections)
      @subway_data = subway_data
      @source = source
      @destination = destination
      @path_connections = path_connections
    end

    def call
      result_path = []
      # First segment
      line = @path_connections[:source_line]
      destination = @path_connections[:connections].first[:station]
      count_stations = @path_connections[:connections].first[:count_stations]
      start_segment = create_segment(line, @source, destination)
      result_path << start_segment

      tail_segments = @path_connections[:connections].each_with_index.map do |conn, index|
        destination = get_destination(@path_connections[:connections][index + 1])
        segment = create_segment(conn[:line], conn[:station], destination)
        result_path << segment
      end
      result_path
    end

    private

    def create_segment(line, source, destination)
      line_data = Lines::LineByNameFinder.call(@subway_data, line)
      {
        line: line,
        source: source,
        destination: destination,
        direction: DirectionBetweenStationsInLine.call(@subway_data, line, source, destination),
        count_stations: Stations::CountBetweenStationsCalculator.call(line_data, source, destination)
      }
    end

    def get_destination(destination)
      return @destination if destination.nil?
      return destination[:station]
    end
  end
end