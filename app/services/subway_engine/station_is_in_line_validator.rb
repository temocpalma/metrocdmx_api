module SubwayEngine
  class StationIsInLineValidator < ApplicationService
    def initialize(target_station, line)
      @target_station = target_station
      @line = line
    end

    def call
      line_stations_names = @line[:stations].map do |station|
        station[:name]
      end
      line_stations_names.include? @target_station
    end
  end
end