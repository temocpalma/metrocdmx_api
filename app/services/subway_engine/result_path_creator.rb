module SubwayEngine
  class ResultPathCreator < ApplicationService
    SAME_LINE = "SAME_LINE"
    DIRECT_INTERSECT = "DIRECT_INTERSECT"
    THIRD_INTERSECT = "THIRD_INTERSECT"

    def initialize(subway_data, source, destination, connections)
      @subway_data = subway_data
      @source = source
      @destination = destination
      @connections = connections
    end

    def call
      result_path = []
      line = @connections[:source_line]

      case @connections[:connection_type]
      when SAME_LINE
        result_path << SegmentCreator.call(@subway_data, line, @source, @destination)
      when DIRECT_INTERSECT
        destination_start_segment = @connections[:intersections].first[:station]
        start_segment = SegmentCreator.call(@subway_data, line, @source, destination_start_segment)
        result_path << start_segment

        destination_line = @connections[:destination_line].find { |line| line == @connections[:intersections].first[:line] }
        last_segment = SegmentCreator.call(@subway_data, destination_line, destination_start_segment, @destination)
        result_path << last_segment
      when THIRD_INTERSECT
        destination_first_segment = @connections[:intersections][:source].first[:station]
        first_segment = SegmentCreator.call(@subway_data, line, @source, destination_first_segment)
        result_path << first_segment

        destination_second_segment = @connections[:intersections][:destination].first[:station]
        line_second_segment = @connections[:intersections][:source].first[:line]
        second_segment = SegmentCreator.call(@subway_data, line_second_segment, destination_first_segment, destination_second_segment)
        result_path << second_segment

        destination_line = @connections[:destination_line]
        last_segment = SegmentCreator.call(@subway_data, destination_line, destination_second_segment, @destination)
        result_path << last_segment
      else
        result_path << {error: "PATH NOT FOUND"}
      end
      puts "Result path: #{result_path}"
      result_path
    end
  end
end