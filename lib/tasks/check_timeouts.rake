namespace :runners_bikers do

  desc "Esegue un check dei timeouts fra le sfide"
  task :check_timeouts => :environment do |t, args|

    Match.check_timeouts

    #aspettiamo 30 secondi per lasciar spedire tutta la posta
    sleep 2.minutes

  end


end
