Types::UserType = GraphQL::ObjectType.define do
  name "User"
  field :id, types.Int
  field :email, types.String
  field :username, types.String
  field :total_points, types.Int, "Il totale dei punti dell'utente"
  field :performances, types[Types::PerformanceType]
  field :matches_as_challenger, types[Types::MatchType]
  field :matches_as_challenged, types[Types::MatchType]
  field :matches_as_winner, types[Types::MatchType]
  field :matches_as_looser, types[Types::MatchType]


end
