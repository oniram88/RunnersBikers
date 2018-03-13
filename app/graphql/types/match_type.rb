Types::MatchType = GraphQL::ObjectType.define do
  name "Match"
  field :challenged, Types::UserType
  field :challenger, Types::UserType
  field :status, types.String
  field :points, types.Int
  field :challenger_performance, Types::PerformanceType
  field :challenged_performance, Types::PerformanceType
  field :judge, Types::UserType
  field :winner, Types::UserType
  field :looser, Types::UserType
  field :note, types.String
end
