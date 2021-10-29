module SubwayEngine::Lines
  class IntersectionBetweenLinesFinder < ApplicationService
    def initialize(source_lines, destination_lines)
      @source_lines = source_lines
      @destination_lines = destination_lines
    end

    def call
      @source_lines & @destination_lines
    end
  end
end