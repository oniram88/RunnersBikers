Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :createMatch, Mutations::CreateMatch.field do
    authorize! :create, record: ->(obj, args, ctx) {Match.new(challenger: ctx[:current_user],
                                                             challenged_id: args[:challenged_id],
                                                             points: args[:points])}

  end

end
