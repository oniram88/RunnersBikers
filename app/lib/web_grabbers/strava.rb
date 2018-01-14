module WebGrabbers
  class Strava < Base

    def grab_data

      distance = web_page.css(".inline-stats .distance strong").first.text.gsub("\n",'')
      puts distance
      self.web_distance = Unit.new(distance).convert_to('km')

      elevation = web_page.css(".inline-stats .elevation strong").first.text.gsub("\n",'').gsub(",",'')
      puts elevation
      self.web_positive_gain = Unit.new(elevation).convert_to('m')

      pace = web_page.css(".inline-stats .avg-speed strong").children.first.text.gsub("\n",'')

      self.web_pace = pace

      nil
    end

  end
end