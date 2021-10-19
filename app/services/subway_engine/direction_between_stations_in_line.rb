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

    def target_line
      @subway_data.select do |line|
        line[:name] == @line
      end
    end

    def station_pos(target_line, target_station)
      stations_names = target_line.first[:stations].map do |station|
        station[:name]
      end
      stations_names.find_index(target_station)
    end

    def direction
      line = target_line
      source_pos = station_pos(line, @source)
      destination_pos = station_pos(line, @destination)
      return "Source and Destination is the same" if source_pos == destination_pos
      return line.first[:stations].last[:name] if source_pos < destination_pos
      line.first[:stations].first[:name] if source_pos > destination_pos
    end

  end
end