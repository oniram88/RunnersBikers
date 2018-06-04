Types::StatisticsType = GraphQL::ObjectType.define do
  name "StatisticsType"
  description "Statistiche del Challenge"


  field :total_distance, types.Int, 'km totali percorsi (tutti correnti)' do
    resolve -> (obj, args, ctx) {
      Performance.sum(:distance)
    }
  end

  field :total_positive_gain, types.Int, 'dislivello totale percorso(tutti correnti)' do
    resolve -> (obj, args, ctx) {
      Performance.sum(:positive_gain)
    }
  end
  field :total_run_time, types.Int, 'tempo totale di corsa di tutti i challengera assieme in secondi' do
    resolve -> (obj, args, ctx) {
      Performance.all.collect(&:running_time).sum
    }
  end

  field :max_positive_gain_in_a_session, types.String, 'dislivello più alto singola sessione' do
    resolve -> (obj, args, ctx) {
      p = Performance.order(:positive_gain => :desc).first
      "#{p.user.full_name} - #{p.distance} km" if p
    }
  end

  field :max_distance_in_a_session, types.String, 'percorso più lungo singola sessione' do
    resolve -> (obj, args, ctx) {
      p = Performance.order(:distance => :desc).first
      "#{p.user.full_name} - #{p.distance} km" if p
    }
  end


  field :max_average_speed_in_a_session, types.String, 'velocità media più alta singola sessione' do
    resolve -> (obj, args, ctx) {
      p = Performance.order(:pace => :asc).first
      "#{p.user.full_name} - #{p.pace}" if p
    }
  end

  field :user_with_max_sessions, types.String, 'utente con più sessioni' do
    resolve -> (obj, args, ctx) {
      begin
        id = Performance.group(:user_id).count.sort_by {|k, v| v}.reverse.first[0]
        user = User.find(id)
        "#{user.full_name} - #{user.performances.count}" if user
      rescue
        ""
      end
    }
  end
end
