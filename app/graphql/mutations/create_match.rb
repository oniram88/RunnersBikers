Mutations::CreateMatch = GraphQL::Relay::Mutation.define do
  name "CreateMatch"
  return_field :result, Types::OperationResultType

  input_field :challenged_id, !types.ID, "User id as challenged"
  input_field :points, types.Int, 'Total Points to be removed from looser'

  resolve ->(obj, args, ctx) {

    @obj = ctx[:current_user].matches_as_challenger.build(args.to_h)
    # authorize @obj
    @obj.save

    {result: @obj}
  }
end
