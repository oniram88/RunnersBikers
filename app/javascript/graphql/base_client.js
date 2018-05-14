import gql from 'graphql-tag'


export const CLIENT_CONFIGURATION = gql`query client_configuration{
    client_configuration{
        user_id
        roles
        username
        program_version
      }
  }`