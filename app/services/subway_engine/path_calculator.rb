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
      source_lines = Lines::LinesByStationFinder.call(@subway_data, @source)
      destination_lines = Lines::LinesByStationFinder.call(@subway_data, @destination)
      intersection_lines = source_lines & destination_lines

      # Path are in same line
      return [ SegmentCreator.call(@subway_data, intersection_lines.first, @source, @destination) ] unless intersection_lines.empty?
      # Path are in distinct lines
      result = stations_in_distinct_lines(source_lines, destination_lines)
      # puts "Result path: #{result}"
      result

    end

    def stations_in_distinct_lines(source_lines, destination_lines)
      # lines intersecting directly
      path_connections = PathConnectionsFinder.call(@subway_data, @source, source_lines, destination_lines)
      return ResultPathCreator.call(@subway_data, @source, @destination, path_connections) unless path_connections.empty?
      # lines intersecting through a third line
      result_path = stations_connected_through_a_third_line(source_lines, destination_lines)

      # connections source lines intersect with connections destination lines
    end

    def stations_connected_through_a_third_line(source_lines, destination_lines)
      line = @subway_data.find { |line| line[:name] == source_lines.first }
      connections_of_source_line = Lines::ConnectionsOfLineFinder.call(line, @subway_data)
      connections_of_source_line_names = connections_of_source_line.map { |conn| conn[:line] }
      path_connections = PathConnectionsFinder.call(@subway_data, @destination, destination_lines, connections_of_source_line_names)
      if !path_connections.empty?
        first_connection = connections_of_source_line.find do |conn|
          conn[:line] == path_connections[:connections].first[:line]
        end
        second_connection = path_connections[:connections].first
        second_connection[:line] = path_connections[:source_line]
        final_path_connections = {source_line: line[:name], connections: [first_connection, second_connection]}
        return ResultPathCreator.call(@subway_data, @source, @destination, final_path_connections)
      end
    end

  end
end