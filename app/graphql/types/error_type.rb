Types::ErrorType = GraphQL::ObjectType.define do
  name "Error"
  field :field, types.String  do
    resolve -> (obj, args, ctx) {
      obj[0]
    }
  end
  field :message, types.String.to_list_type do
    resolve -> (obj, args, ctx) {
      obj[1]
    }
  end
end
