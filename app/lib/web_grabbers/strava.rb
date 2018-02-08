module WebGrabbers
  class Strava < Base

    def grab_data

      distance = web_page.css(".inline-stats .distance strong").first
      if distance
        distance = distance.text.gsub("\n", '')
        puts distance
        self.web_distance = Unit.new(distance).convert_to('km').scalar
      end

      elevation = web_page.css(".inline-stats .elevation strong").first
      if elevation
        elevation = elevation.text.gsub("\n", '').gsub(",", '')
        puts elevation
        self.web_positive_gain = Unit.new(elevation).convert_to('m').scalar
      end

      moving_time = web_page.css(".inline-stats .moving-time strong").first
      if moving_time
        moving_time = moving_time.text.gsub("\n", '')
        puts moving_time
        self.web_moving_time = moving_time
      end


      pace = web_page.css(".inline-stats .avg-speed strong").children.first
      if pace
        pace = pace.text.gsub("\n", '')
        self.web_pace = pace
      end

      nil
    rescue Exception => e

      Rails.logger.debug { "Errore con url:#{performance.url}" }

      raise GrabError.new(e.message)

    end

  end
end