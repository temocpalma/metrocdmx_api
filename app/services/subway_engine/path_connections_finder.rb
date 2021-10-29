module SubwayEngine
  class PathConnectionsFinder < ApplicationService
    def initialize(subway_data, source, source_lines, destination_lines)
      @subway_data = subway_data
      @source = source
      @source_lines = source_lines
      @destination_lines = destination_lines
    end

    def call
      get_path_connections(0, [])
    end

    private

    def get_path_connections(index, path_connections)
      return {source_line: @source_lines[index - 1], connections: path_connections} unless path_connections.empty?
      return {} unless index < @source_lines.size

      line = @subway_data.find { |line| line[:name] == @source_lines[index] }
      connections_of_line = ConnectionsOfLineFinder.call(line, @subway_data)
      connection_names = connections_line_names(connections_of_line)
      intersection_lines = IntersectionBetweenLinesFinder.call(
        connection_names,
        @destination_lines
      )

      path_connections = intersection_lines.map do |inter|
        connections_of_line.find { |conn| conn[:line] == inter }
      end
      path_connections = select_nearest_connection(path_connections, line)
      get_path_connections(index+=1, path_connections)
    end

    def connections_line_names(connections_line)
      connections_line.map { |conn| conn[:line] }
    end

    def select_nearest_connection(path_connections, line)
      return path_connections if path_connections.empty?
      path_connections_with_count_stations = path_connections.map do |conn|
        conn[:count_stations] = Stations::CountBetweenStationsCalculator.call(line, @source, conn[:station])
        conn
      end

      sort_path_connections = path_connections_with_count_stations.sort { |l1, l2| l1[:count_stations] <=> l2[:count_stations] }

      [sort_path_connections.first]
    end

  end
end