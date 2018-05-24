Mutations::SetReferalPoints = GraphQL::Relay::Mutation.define do
  name "SetReferalPoints"
  # TODO: define return fields
  # return_field :post, Types::PostType

  # TODO: define arguments
  input_field :user_id, !types.ID, 'Id utente'
  input_field :points, !types.Int, 'Punti da impostare all\'utente'

  return_field :result, Types::OperationResultType

  resolve ->(obj, args, ctx) {

    user = User.find(args[:user_id])
    user.referal_points = args[:points]

    user.save
    {result: user}

  }
end
