module SubwayEngine::Stations
  class StationPositionInLineFinder < ApplicationService
    def initialize(line, station)
      @line = line
      @station = station
    end

    def call
      stations_names = @line[:stations].map do |station|
        station[:name]
      end
      stations_names.find_index(@station)
    end
  end
end