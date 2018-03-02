namespace :runners_bikers do
  namespace :results do

    desc "General Order"
    task :general_order => :environment do |t, args|

      User.all.order(:total_points => :desc).each do |u|

        puts [u.rank, u.full_name, u.total_points, u.performances.sum(:distance)].join(',')

      end

    end

    desc "Totals"
    task :totals => :environment do |t, args|

      puts "Distanza totale: #{Performance.sum(:distance)}"
      puts "Dislivello totale: #{Performance.sum(:positive_gain)}"
      puts "Numero sessioni totali: #{Performance.count}"
      puts "Numero sfide totali: #{Match.count}"

    end

    desc "Classifica per dislivello"
    task :climbing_order => :environment do |t, args|

      Performance.group(:user_id).sum(:positive_gain).sort_by {|a,b| b }.reverse.each do |p|

        puts [User.find(p[0]).full_name, p[1]].join(',')

      end

    end


  end
end