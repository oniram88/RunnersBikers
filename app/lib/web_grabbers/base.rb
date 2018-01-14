require 'nokogiri'
require 'open-uri'
require 'ruby-units'
module WebGrabbers
  class Base

    attr_accessor :performance
    attr_accessor :web_pace
    attr_accessor :web_distance
    attr_accessor :web_positive_gain


    def initialize(performance)
      self.performance = performance
    end


    def grab_data
      @web_pace = nil
      @web_distance = nil
      @web_positive_gain = nil
      @web_duration = nil
    end

    def web_page
      @web_page ||= Nokogiri::HTML(open(self.performance.url))
    end


  end
end