RunnersBikersSchema = GraphQL::Schema.define do
  instrument(:field, GraphQL::Pundit::Instrumenter.new)
  mutation(Types::MutationType)
  query(Types::QueryType)
end
