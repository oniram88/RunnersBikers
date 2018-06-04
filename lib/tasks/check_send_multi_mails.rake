namespace :runners_bikers do

  desc "Rake task da lanciare giornalmente per l'invio di determinate emails"
  task :daily_check_send_multi_mails => :environment do |t, args|


    if Date.today == RunnersBikers::TIME_TO_START_CHALLENGES.to_date
      puts "Spedisco le emails di inizio sfida"
      User.all.each do |u|

        MatchNotifierMailer.with(user: u).activation_matches.deliver_now

      end
    end


  end
end
