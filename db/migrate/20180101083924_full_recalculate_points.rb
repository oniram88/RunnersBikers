class FullRecalculatePoints < ActiveRecord::Migration[5.1]
  def change

    Performance.transaction do

      Performance.all.each do |p|
        p.save
      end


      User.all.each do |u|

        if u.first_name.blank?
          u.first_name = "nome casuale #{u.id}"
        end

        if u.last_name.blank?
          u.last_name = "cognome casuale #{u.id}"
        end

        u.save

        points = u.performances.reload.sum(:points)
        u.update_attributes!(total_points: points)
      end

      Match.all.each do |m|
        real_max_points = m.challenged.total_points * 0.25
        m.update_attribute(:points, real_max_points) if m.points > real_max_points
      end

      User.all.each do |u|
        u.update_points
      end

      counts = 0
      while ::SuckerPunch::Queue.stats["ActiveJob::QueueAdapters::SuckerPunchAdapter::JobWrapper"]["workers"]["busy"] > 0
        puts "attendo #{counts}"
        counts += 1
        sleep(1)
      end

    end


  end
end
