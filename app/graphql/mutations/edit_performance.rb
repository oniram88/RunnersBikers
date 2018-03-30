Mutations::EditPerformance = GraphQL::Relay::Mutation.define do
  name "EditPerformance"

  return_field :result, Types::OperationResultType


  input_field :distance, types.Float
  input_field :pace, types.String
  input_field :positive_gain, types.Int
  input_field :url, types.String

  input_field :id, !types.ID, "performance_id"

  resolve ->(obj, args, ctx) {

    @obj = Performance.find(args.id)

    @obj.update_attributes(args.to_h)

    {result: @obj}
  }

end
