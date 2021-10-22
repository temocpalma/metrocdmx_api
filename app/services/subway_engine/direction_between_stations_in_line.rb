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

    def get_target_line
      @subway_data.find do |line|
        line[:name] == @line
      end
    end

    def get_station_pos(target_line, target_station)
      stations_names = target_line[:stations].map do |station|
        station[:name]
      end
      stations_names.find_index(target_station)
    end

    def direction
      line = get_target_line
      source_pos = get_station_pos(line, @source)
      destination_pos = get_station_pos(line, @destination)

      return "#{@source} does not exists in #{@line}" if source_pos.nil?
      return "#{@destination} does not exists in #{@line}" if destination_pos.nil?
      return "Source and Destination is the same" if source_pos == destination_pos
      return line[:stations].last[:name] if source_pos < destination_pos
      line[:stations].first[:name] if source_pos > destination_pos
    end

  end
end