namespace :runners_bikers do
  namespace :utils do

    desc "In Sviluppo esegue una pulizia password e conferma tutti gli account"
    task :prepare_dev => :environment do |t, args|

      User.all.each do |u|

        puts "#{u.email} - #{u.username} - #{u.first_name} - #{u.last_name}"
        u.password='ciaociao'
        u.confirmed_at=Time.now
        u.save!

      end

    end


    desc "Correct first match"
    task :correct_first_match => :environment do


      Performance.transaction do

        m = Match.first

        vecchia_performance = m.challenger_performance

        correct_performance = Performance.find(272)

        m.update_attributes(challenger_performance: correct_performance)

        vecchia_performance.update_attributes(:distance=>8.11)

        User.all.each{|u| u.update_points}
        User.update_rank
      end


    end

  end
end
