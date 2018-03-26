Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.


  field :user do
    type Types::UserType
    argument :id, !types.ID
    description "Find a User by ID"
    resolve ->(obj, args, ctx) {User.find(args["id"])}
  end

  field :users do
    type Types::UserType.to_list_type
    argument :limit, types.Int
    description "List of all users"
    after_scope
    resolve ->(obj, args, ctx) do

      q = User.all

      unless args[:limit].blank?
        q = q.limit(args[:limit])
      end

      q

    end
  end


  field :rankings do
    type Types::RankingType.to_list_type
    argument :id, types.ID, 'Ranking per un determinato id'
    argument :limit, types.Int, default_value: 100, prepare: ->(limit, ctx) {[limit, 100].min}
    description "List of all users"
    # after_scope
    resolve ->(obj, args, ctx) do
      if args[:id]
        Ranking.where(id: args[:id])
      else
        Ranking.order(:rank => :asc).limit(args[:limit])
      end

    end
  end
end
