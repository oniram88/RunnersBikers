Types::MatchType = GraphQL::ObjectType.define do
  name "Match"
  field :id, types.Int
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
  field :expiration_date, types.String do
    resolve ->(obj, args, ctx) {
      obj.expiration_date.to_datetime.rfc3339
    }
  end

  field :approvable, types.Boolean do
    description 'if the match can be approved'
    resolve ->(obj, args, ctx) {
      MatchPolicy.new(ctx[:current_user], obj).approve?
    }
  end

  field :note_updatable, types.Boolean do
    description 'if the note can be update from current user'
    resolve ->(obj, args, ctx) {
      MatchPolicy.new(ctx[:current_user], obj).note_updatable?
    }
  end
end
