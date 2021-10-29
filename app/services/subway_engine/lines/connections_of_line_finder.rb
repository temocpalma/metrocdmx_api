module SubwayEngine::Lines
  class ConnectionsOfLineFinder < ApplicationService
    def initialize(target_line, all_lines)
      @target_line = target_line
      @all_lines = all_lines
    end

    def call
      searching_lines = @all_lines.reject { |line| line[:name] == @target_line[:name] }
      connections_lines = []
      @target_line[:stations].each do |station|
        searching_lines.each do |line|
          connections_lines << {line: line[:name], station: station[:name]} if SubwayEngine::Stations::StationIsInLineValidator.call(station[:name], line)
        end
      end
      connections_lines.sort { |l1, l2| l1[:line] <=> l2[:line] }
    end

  end
end