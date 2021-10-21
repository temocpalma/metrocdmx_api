module SubwayEngine
  class PathConnectionsFinder < ApplicationService
    def initialize(subway_data, source_lines, destination_lines)
      @subway_data = subway_data
      @source_lines = source_lines
      @destination_lines = destination_lines
    end

    def call
      get_path_connections(@source_lines, @destination_lines, 0, [])
    end

    private

    def get_path_connections(source_lines, destination_lines, index, path_connections)
      return path_connections if (not path_connections.empty?) or (index > source_lines.size - 1)
      line = @subway_data.find { |line| line[:name] == source_lines[index] }
      connections_of_line = ConnectionsOfLineFinder.call(line, @subway_data)
      connection_names = connections_line_names(connections_of_line)
      intersection_lines = IntersectionBetweenLinesFinder.call(
        connection_names,
        destination_lines
      )

      path_connections = intersection_lines.map do |inter|
        connections_of_line.find { |conn| conn[:name] == inter }
      end
      get_path_connections(source_lines, destination_lines, index+=1, path_connections)
    end

    def connections_line_names(connections_line)
      connections_line.map { |conn| conn[:name] }
    end

  end
end