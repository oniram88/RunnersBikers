Mutations::DeletePerformance = GraphQL::Relay::Mutation.define do
  name "DeletePerformance"

  return_field :result, Types::OperationResultType

  input_field :id, !types.ID, "performance_id"


  resolve ->(obj, args, ctx) {

    @obj = Performance.find(args.id)

    @obj.destroy

    {result: @obj}
  }

end
