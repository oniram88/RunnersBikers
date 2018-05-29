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

  # field :session_max_positive_gain,description:'dislivello più alto singola sessione'
  # field :session_max_distance,description:'percorso più lungo singola sessione'
  # field :session_max_average_speed,description:'velocità media più alta singola sessione'
  # field :user_with_max_sessions,description:'utente che ha fatto più sessioni'
end
