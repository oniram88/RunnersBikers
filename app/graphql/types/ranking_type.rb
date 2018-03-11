Types::RankingType = GraphQL::ObjectType.define do
  name "Ranking"
  field :id, types.Int
  field :total_distance, types.Int
  field :total_positive_gain, types.Int
  field :rank, types.Int
  field :username, types.String
  field :total_points, types.Int
end
