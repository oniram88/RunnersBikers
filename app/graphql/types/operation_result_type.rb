Types::OperationResultType = GraphQL::ObjectType.define do
  name "OperationResult"
  # field :object, Types::ObjectType do
  #   resolve -> (obj, args, ctx) {
  #     obj
  #   }
  #
  # end
  field :errors, types[Types::ErrorType] do
    resolve -> (obj, args, ctx) {
      obj.errors.as_json
    }

  end
  field :result, types.Boolean do
    resolve -> (obj, args, ctx) {
      obj.valid?
    }
  end
end
