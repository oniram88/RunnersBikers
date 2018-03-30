Types::PerformanceType = GraphQL::ObjectType.define do
  name "Performance"
  field :id, types.Int
  field :distance, types.Float
  field :pace, types.String
  field :positive_gain, types.Int
  field :user_id, types.Int
  field :url, types.String
  field :points, types.Int
  field :created_at, types.String do
    resolve ->(obj, args, ctx) {
      obj.created_at.to_datetime.rfc3339
    }
  end

  field :destructible, types.Boolean do
    resolve -> (obj, args, ctx) {
      !PerformancePolicy.new(ctx[:current_user], obj).destroy?
    }
  end

  field :editable, types.Boolean do
    resolve -> (obj, args, ctx) {
      !PerformancePolicy.new(ctx[:current_user], obj).update?
    }
  end

  field :readonly, types.Boolean do
    resolve -> (obj, args, ctx) {
      !PerformancePolicy.new(ctx[:current_user], obj).update?
    }
  end
end
