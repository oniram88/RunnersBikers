Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :createMatch, Mutations::CreateMatch.field

end
