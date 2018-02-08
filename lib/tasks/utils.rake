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

  end
end
