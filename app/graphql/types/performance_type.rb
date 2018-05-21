Types::PerformanceType = GraphQL::ObjectType.define do
  name "Performance"
  field :id, types.Int

  field :distance, types.Float do
    authorize
  end
  field :pace, types.String do
    authorize
  end
  field :positive_gain, types.Int do
    authorize
  end
  field :user_id, types.Int do
    authorize
  end
  field :url, types.String do
    authorize
  end
  field :points, types.Int do
    authorize
  end


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
