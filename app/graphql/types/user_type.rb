Types::UserType = GraphQL::ObjectType.define do
  name "User"
  field :id, types.Int
  field :email, types.String
  field :total_points, types.Int
  field :performances, types[Types::PerformanceType]
end
