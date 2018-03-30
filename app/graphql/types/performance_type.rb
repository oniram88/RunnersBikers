Types::PerformanceType = GraphQL::ObjectType.define do
  name "Performance"
  field :id, types.Int
  field :distance, types.Float
  field :pace, types.String
  field :positive_gain, types.Int
  field :url, types.String
  field :points, types.Int

  field :readonly, types.Boolean do
    resolve -> (obj, args, ctx) {
      !PerformancePolicy.new(ctx[:current_user], obj).update?
    }
  end
end
