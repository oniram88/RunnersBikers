Types::RankingType = GraphQL::ObjectType.define do
  name "Ranking"
  field :id, types.Int
  field :total_distance, types.Int, "Total Run distance for user"
  field :total_positive_gain, types.Int, "Total Positive Gain run for user"
  field :rank, types.Int, "Ranking in the challenger"
  field :username, types.String
  field :first_name, types.String
  field :last_name, types.String
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

  field :show_performances, types.Boolean, "Can be shown the performances of user" do
    resolve -> (obj, args, ctx) {
      UserPolicy.new(ctx[:current_user], obj).show_performances?
    }
  end

  field :user, Types::UserType, "posso estrapolare direttamente i dati dell'utente" do
    resolve ->(obj, args, ctx) {
      obj.becomes(User)
    }
  end

end
