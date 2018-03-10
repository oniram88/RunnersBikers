Types::PerformanceType = GraphQL::ObjectType.define do
  name "Performance"
  field :id, types.Int
  field :distance, types.Float
  field :pace, types.String
  field :positive_gain, types.Int
  field :url, types.String
  field :points, types.Int
end
