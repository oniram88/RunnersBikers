Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.


  field :user do
    type Types::UserType
    argument :id, types.ID
    description "Find a User by ID,or get the current user"
    authorize! :show, record: ->(obj, args, ctx) {
      if args["id"]
        User.find(args["id"])
      else
        ctx[:current_user]
      end
    }
    resolve ->(obj, args, ctx) {
      if args["id"]
        User.find(args["id"])
      else
        ctx[:current_user]
      end
    }
  end

  field :performance do
    type Types::PerformanceType
    argument :id, !types.ID
    description "Find a performance by ID"
    authorize! :show, record: ->(obj, args, ctx) {Performance.find(args['id'])}
    resolve ->(obj, args, ctx) {Performance.find(args["id"])}
  end

  field :performances do
    type Types::PerformanceType.to_list_type
    argument :limit, types.Int
    argument :user_id do
      type types.ID
      default_value nil
      description "Possibile passare l'id della persona su
                                  cui scoppare la ricerca delle performances,
                                  altrimenti le proprie"
      prepare ->(value, ctx) {
        value || ctx[:current_user].id
      }
    end
    description "Get own performances or of an other user"
    before_scope ->(_root, _args, ctx) {PerformancePolicy.new(ctx[:current_user], Performance.new).scope.all}
    resolve ->(performances, args, ctx) {

      if args[:user_id]
        performances = performances.where(user_id: args[:user_id])
      end

      unless args[:limit].blank?
        performances = performances.limit(args[:limit])
      end

      performances.to_a
    }
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

  field :client_configuration do
    type Types::ClientConfiguration
    description ""
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
