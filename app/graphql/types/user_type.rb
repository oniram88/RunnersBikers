Types::UserType = GraphQL::ObjectType.define do
  name "User"
  field :email, types.String
  field :total_points, types.Int
  field :performances, types[Types::PerformanceType]
end