Mutations::UpdateMatch = GraphQL::Relay::Mutation.define do
  name "UpdateMatch"

  return_field :result, Types::OperationResultType


  input_field :note, types.String

  input_field :id, !types.ID, "match id"

  resolve ->(obj, args, ctx) {

    @obj = Match.find(args.id)

    @obj.update_attributes(args.to_h)

    {result: @obj}
  }

end
