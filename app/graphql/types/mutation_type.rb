Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :editPerformance, Mutations::EditPerformance.field do

    authorize! :update, record: ->(obj, args, ctx) {Performance.find(args[:id])}

  end
  # field :createPerformance, Mutations::CreatePerformance.field
  field :createMatch, Mutations::CreateMatch.field do
    authorize! :create, record: ->(obj, args, ctx) {Match.new(challenger: ctx[:current_user],
                                                              challenged_id: args[:challenged_id],
                                                              points: args[:points])}

  end

end
