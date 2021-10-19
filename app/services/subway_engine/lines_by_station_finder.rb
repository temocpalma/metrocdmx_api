module SubwayEngine
  class LinesByStationFinder < ApplicationService

    def initialize(subway_data, station)
      @subway_data = subway_data
      @station = station
    end

    def call
      lines_for_station
    end

    private

    def lines_for_station
      station_target_lines = @subway_data.filter do |line|
        stations_names = line[:stations].map do |station|
          station[:name]
        end
        stations_names.include? @station
      end

      station_target_lines.map do |line|
        line[:name]
      end
    end
  end

end