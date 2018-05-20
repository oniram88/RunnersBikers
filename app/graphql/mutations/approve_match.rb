Mutations::ApproveMatch = GraphQL::Relay::Mutation.define do
  name "ApproveMatch"

  return_field :result, Types::OperationResultType

  input_field :id, !types.ID, "match id"

  resolve ->(obj, args, ctx) {

    @obj = Match.find(args.id)

    @obj.approve(ctx[:current_user])

    {result: @obj}
  }

end
