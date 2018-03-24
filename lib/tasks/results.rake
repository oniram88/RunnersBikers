namespace :runners_bikers do
  namespace :results do

    desc "Lancia tutti i task"
    task :all => :environment do | |

      [:totals, :general_order, :climbing_order, :pace_order, :order_inclination, :order_matches, :match_minor_difference].each do |t|

        Rake::Task["runners_bikers:results:#{t}"].invoke
        puts "============== #{t} ================="
        puts ""
        puts ""
      end


    end

    def title(title)
      puts "============== #{title} ================="

    end

    desc "General Order"
    task :general_order => :environment do |t, args|

      title "General Order"

      User.all.order(:total_points => :desc).each do |u|

        puts [u.rank, u.full_name, u.total_points, "#{u.performances.sum(:distance)} km"].join(' , ')

      end

    end

    desc "Totals"
    task :totals => :environment do |t, args|

      title "Totals"

      puts "Distanza totale: #{Performance.sum(:distance)}km"
      puts "Dislivello totale: #{Performance.sum(:positive_gain)}m"
      puts "Numero sessioni totali: #{Performance.count}"
      puts "Numero sfide totali: #{Match.count}"

      #passo medio
      puts "Passo medio: #{PaceType.new.deserialize((Performance.select('sum(pace) as passo')).first[:passo] / Performance.count)}"

    end

    desc "Classifica per dislivello"
    task :climbing_order => :environment do |t, args|

      title "Classifica per dislivello"

      contatore = 1

      Performance.group(:user_id).sum(:positive_gain).sort_by {|a, b| b}.reverse.each do |p|

        puts [contatore, User.find(p[0]).full_name, "#{p[1]} m"].join(' , ')

        contatore += 1
      end

    end

    desc "Classifica per passo medio"
    task :pace_order => :environment do |t, args|

      title "Classifica per passo medio"

      contatore = 1
      User.all.joins(:performances).uniq.collect {|u|


        begin
          value = u.performances.select('sum(pace) as passo').first[:passo] / u.performances.count
        rescue
          value = 9999999999999
        end


        [u.full_name, value]

      }.sort_by {|a, b| b}.collect {|a, b| [a, PaceType.new.deserialize(b)]}.each do |l|

        puts [contatore, l].flatten.join(' , ')
        contatore += 1
      end


    end

    desc "Classifica per pendenza"
    task :order_inclination => :environment do |t, args|

      title "Classifica per pendenza"

      contatore = 1
      User.all.joins(:performances).uniq.collect do |u|

        [u.full_name, "#{((u.performances.sum(:positive_gain) / 1000.0 / u.performances.sum(:distance)) * 100.0).round(3)} %"]

      end.sort_by {|a, b| b}.reverse.each do |l|
        puts [contatore, l].flatten.join(' , ')
        contatore += 1
      end


    end

    desc "Classifica per sfide vinte/fatte"
    task :order_matches => :environment do |t, args|


      title "Classifica per sfide vinte/fatte"

      contatore = 1
      User.all.collect do |u|
        [u.full_name, u.matches_as_winner.count, u.matches_as_challenger.count + u.matches_as_challenged.count, u.matches_as_winner.sum(:points), u.matches_as_looser.sum(:points)]
      end.sort_by {|a, b| b}.reverse.each do |l|
        puts [contatore, l[0], "#{l[1]}/#{l[2]}", "Punti conquistati:#{l[3]}", "Punti persi:#{l[4]}"].flatten.join(' , ')
        contatore += 1
      end
    end


    desc "Ordine per minor differenza di punteggio nella sfida"
    task :match_minor_difference => :environment do |t, args|


      title "Ordine sfide per minor differenza di punteggio"
      contatore = 1
      Match.approved.collect do |a|
        ["#{a.challenger.full_name} VS #{a.challenged.full_name} ", (a.challenged_performance.points - a.challenger_performance.points).abs]
      end.sort_by {|a, b| b}.each do |l|
        puts [contatore, l].flatten.join(' , ')
        contatore += 1
      end
    end

    desc "Estrae CSV con tutti i dati delle sessioni"
    task :extract_session_data => :environment do |t, args|
      CSV.open(Rails.application.root.join('tmp', "sessioni_#{Time.now}.csv"), "wb") do |csv|
        csv << ['nome', 'cognome', 'data', 'distanza m', 'passo', 'passo in s', 'dislivello m', 'url']
        Performance.all.includes(:user).order(:id).each do |p|
          data = [p.user.first_name, p.user.last_name, p.created_at, (p.distance * 1000).to_i, p.pace, PaceType.to_seconds(p.pace), p.positive_gain, p.url]
          puts data.inspect
          csv << data
        end

      end
    end

    desc "Estrae CSV con tutti i dati raggruppati per utenti"
    task :extract_user_data => :environment do |t, args|
      CSV.open(Rails.application.root.join('tmp', "user_#{Time.now}.csv"), "wb") do |csv|
        csv << ['nome', 'cognome', 'distanza km', 'dislivello m', 'passo', 'passo in s']

        User.all.joins(:performances).uniq.each {|u|

          begin
            value = u.performances.select('sum(pace) as passo').first[:passo] / u.performances.count

            csv << [u.first_name, u.last_name, u.performances.sum(:distance), u.performances.sum(:positive_gain), PaceType.new.deserialize(value), value]
          rescue
            puts "errore per #{u.full_name}"
          end

        }

      end
    end

  end
end