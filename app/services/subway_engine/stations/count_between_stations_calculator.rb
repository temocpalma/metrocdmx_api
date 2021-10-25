module SubwayEngine::Stations
  class CountBetweenStationsCalculator < ApplicationService
    def initialize(line, station_one, station_two)
      @line = line
      @station_one = station_one
      @station_two = station_two
    end

    def call
      position_one = StationPositionInLineFinder.call(@line, @station_one)
      position_two = StationPositionInLineFinder.call(@line, @station_two)
      return nil if position_one.nil? or position_two.nil?

      (position_one - position_two).abs
    end
  end
end