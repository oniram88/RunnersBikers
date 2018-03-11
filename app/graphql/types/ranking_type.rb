Types::RankingType = GraphQL::ObjectType.define do
  name "Ranking"
  field :id, types.Int
  field :total_distance, types.Int, "Total Run distance for user"
  field :total_positive_gain, types.Int, "Total Positive Gain run for user"
  field :rank, types.Int, "Ranking in the challenger"
  field :username, types.String
  field :total_points, types.Int, "Total points in the match"

  field :challenged, types.Boolean, "If the user is inside a challenge" do
    resolve ->(obj, args, ctx) {
      obj.open_matches.length > 0
    }
  end

  field :machable, types.Boolean, "If the user can be matched" do
    resolve ->(obj, args, ctx) {
      ctx[:current_user].machable(obj)
    }
  end

  field :max_lose_points, types.Int, "Max points to loose in a match" do
    resolve ->(obj, args, ctx) {
      obj.max_lose_points(ctx[:current_user])
    }
  end

end
