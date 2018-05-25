Types::ClientConfiguration = GraphQL::ObjectType.define do
  name "ClientConfiguration"
  description "Configurazioni base del client, ruoli utente loggato e versione programma "



  field :program_version, types.String  do
    resolve -> (obj, args, ctx) {
      RunnersBikers::VERSION
    }
  end
  field :roles, types.String.to_list_type do
    resolve -> (obj, args, ctx) {
      obj.roles.collect(&:name)
    }
  end

  field :user_id, types.Int do
    resolve -> (obj, args, ctx) {
      obj.id
    }
  end

  field :username, types.String
  field :first_name, types.String
  field :last_name, types.String
  field :referal_points, types.Int
  field :total_points,types.Int

end
