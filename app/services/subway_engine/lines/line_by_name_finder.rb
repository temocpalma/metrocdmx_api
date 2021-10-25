module SubwayEngine::Lines
  class LineByNameFinder < ApplicationService
    def initialize(subway_data, line_name)
      @subway_data = subway_data
      @line_name = line_name
    end

    def call
      @subway_data.find do |line|
        line[:name] == @line_name
      end
    end
  end
end