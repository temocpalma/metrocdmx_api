require 'ox'

class SubwayDescriptor < ApplicationService
  def initialize(data)
  end

  def call
    get_data
  end

  private

  def get_kml_hash
    xmlFile = File.read("#{Rails.root}/public/metrocdmx.kml")
    Ox.load(xmlFile, mode: :hash_no_attrs)
  end

  def get_lines
    data = get_kml_hash
    data[:kml][:Document][:Folder].first[:Placemark].map do |line|
      { name: line[:name], stations_coords: line[:LineString][:coordinates].strip.split(" ") }
    end
  end

  def get_stations
    data = get_kml_hash
    data[:kml][:Document][:Folder][1][:Placemark].map do |station|
      { name: station[:name], coordinates: station[:Point][:coordinates].strip }
    end
  end

  def get_data
    lines = get_lines
    stations = get_stations

    lines.map do |line|
      line_stations = line[:stations_coords].map do |coord|
        stations.filter do |station|
          station[:coordinates] == coord
        end
      end
      { name: line[:name], stations: line_stations }
    end
  end
end