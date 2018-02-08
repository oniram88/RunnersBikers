require 'nokogiri'
require 'open-uri'
require 'ruby-units'
module WebGrabbers
  class Base

    attr_accessor :performance
    attr_accessor :web_pace
    attr_accessor :web_distance
    attr_accessor :web_positive_gain
    attr_accessor :web_moving_time


    GrabError = Class.new(StandardError)

    def initialize(performance)
      self.performance = performance
      self.grab_data
    end


    def grab_data
      @web_pace = nil
      @web_distance = nil
      @web_positive_gain = nil
      @web_duration = nil
      @web_moving_time = nil
    end

    def web_page
      @web_page ||= Nokogiri::HTML(open(self.performance.url))
    end

    def same_data?

      tc = Performance.new(pace: web_pace, distance: web_distance, positive_gain: web_positive_gain)

      unless PaceType.to_seconds(tc.pace).to_f == PaceType.to_seconds(performance.pace)
        Rails.logger.info { "#{tc.pace} == #{performance.pace}" }
        return false
      end

      unless tc.distance == performance.distance
        Rails.logger.info { "#{tc.distance} == #{performance.distance}" }
        return false
      end

      unless tc.positive_gain == performance.positive_gain
        Rails.logger.info { "#{tc.positive_gain} == #{performance.positive_gain}" }
        return false
      end

      true
    end


  end
end