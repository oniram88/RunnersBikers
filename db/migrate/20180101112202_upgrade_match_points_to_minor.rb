class UpgradeMatchPointsToMinor < ActiveRecord::Migration[5.1]
  def change


    Match.transaction do
      Match.open_matches.all.each do |m|
        max_points = Ranking.max_loose_points(m.challenger, m.challenged)
        puts "#{m.points} > #{max_points}"
        if m.points > max_points
          puts "Aggiornamento punteggio #{max_points}"
          m.update_attribute(:points, max_points)
        end

      end
    end

  end
end
