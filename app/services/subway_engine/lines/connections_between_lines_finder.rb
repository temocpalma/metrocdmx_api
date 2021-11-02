module SubwayEngine::Lines
  class ConnectionsBetweenLinesFinder < ApplicationService
    SAME_LINE = "SAME_LINE"
    DIRECT_INTERSECT = "DIRECT_INTERSECT"
    THIRD_INTERSECT = "THIRD_INTERSECT"

    def initialize(subway_data, source_lines, destination_lines)
      @subway_data = subway_data
      @source_lines = source_lines
      @destination_lines = destination_lines
    end

    def call
      connections_finder(@source_lines, @destination_lines, 0, 0, {case: SAME_LINE})
    end

    private

    def connections_finder(source_lines, destination_lines, source_index, destination_index, result)
      return result if result[:case] == "DONE"
      current_case = result[:case]

      puts "###############################"
      puts "current case: #{current_case}"
      puts "source lines size: #{source_lines.size}"
      puts "destination lines size: #{destination_lines.size}"

      case current_case
      when SAME_LINE
        result = connection_in_same_line(source_lines, destination_lines)
      when DIRECT_INTERSECT
        result = connection_in_direct_intersect(source_lines, destination_lines, source_index)
        source_index = result[:source_index]
      when THIRD_INTERSECT
        result = connection_through_third_line(source_lines, destination_lines, source_index, destination_index)
        source_index = result[:source_index]
        destination_index = result[:destination_index]
      else
        result = {case: "DONE"}
      end
      connections_finder(source_lines, destination_lines, source_index, destination_index, result)
    end

    def connection_in_same_line(source_lines, destination_lines)
      puts "SAME_LINE ---->"
      intersections = source_lines & destination_lines
      puts "Intersections: #{intersections}"
      result = intersections.empty? ? {case: DIRECT_INTERSECT}
        : {source_line: intersections, intersections: intersections, destination_line: intersections, case: "DONE"}
      puts "result: #{result}"
      return result
    end

    def connection_in_direct_intersect(source_lines, destination_lines, source_index)
      result = {case: "DONE", source_index: source_index}
      if source_index < source_lines.size
        puts "DIRECT_INTERSECT ---->"
        puts "source_index: #{source_index}"
        source_line = source_lines[source_index]
        source_line_data = @subway_data.find { |line| line[:name] == source_line }
        connections_source_line = ConnectionsOfLineFinder.call(source_line_data, @subway_data)
        connections_names = connections_source_line.map { |conn| conn[:line] }

        intersections = connections_names & destination_lines
        puts "Intersections: #{intersections}"

        result = intersections.empty? ? {case: DIRECT_INTERSECT, source_index: source_index + 1}
          : {source_line: source_line, intersections: intersections, destination_line: intersections, case: "DONE", source_index: source_index}
      else
        puts "else direct intersect source index: #{source_index}"
        result = {case: THIRD_INTERSECT, source_index: 0}
      end

      puts "result: #{result}"
      return result
    end

    def connection_through_third_line(source_lines, destination_lines, source_index, destination_index)
      result = {case: "DONE", source_index: source_index, destination_index: destination_index}
      if destination_index < destination_lines.size
        puts "THIRD_INTERSECT ---->"
        puts "source index: #{source_index}"
        puts "destination index: #{destination_index}"

        if source_index > source_lines.size + 1
          result = {
            source_line: source_lines,
            intersections: [],
            destination_line: destination_lines,
            case: "DONE",
            source_index: source_index,
            destination_index: destination_index
          }
        else
          source_line = source_lines[source_index]
          source_line_data = @subway_data.find { |line| line[:name] == source_line }
          connections_source_line = ConnectionsOfLineFinder.call(source_line_data, @subway_data)
          connections_source_names = connections_source_line.map { |conn| conn[:line] }

          destination_line = destination_lines[destination_index]
          destination_line_data = @subway_data.find { |line| line[:name] == destination_line }
          connections_destination_line = ConnectionsOfLineFinder.call(destination_line_data, @subway_data)
          connections_destination_names = connections_destination_line.map { |conn| conn[:line] }
          puts "Connections source line: #{connections_source_line}"
          puts "Connections destination line: #{connections_destination_line}"

          intersections = connections_source_names & connections_destination_names
          puts "Intersections: #{intersections}"

          result = intersections.empty? ? {case: THIRD_INTERSECT, source_index: source_index, destination_index: destination_index + 1}
            : {source_line: source_line, intersections: intersections, destination_line: destination_line, case: "DONE", source_index: source_index, destination_index: destination_index}
        end
      else
        result = {case: THIRD_INTERSECT, source_index: source_index + 1, destination_index: 0}
      end

      puts "result: #{result}"
      return result
    end
  end
end