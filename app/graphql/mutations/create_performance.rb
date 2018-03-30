Mutations::CreatePerformance = GraphQL::Relay::Mutation.define do
  name "CreatePerformance"

  return_field :result, Types::OperationResultType


  input_field :distance, types.Float
  input_field :pace, types.String
  input_field :positive_gain, types.Int
  input_field :url, types.String


  resolve ->(obj, args, ctx) {

    @obj = ctx[:current_user].performances.create(args.to_h)

    {result: @obj}
  }


end
