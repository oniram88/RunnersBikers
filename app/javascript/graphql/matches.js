import gql from 'graphql-tag'


export const GET_MATCHES = gql`query matches {
  matches {
    id
     
    challenger {
      username
    }
    challenged {
      username
    }
    challenged_performance{
      id
      user_id
    }
    challenger_performance{
      id
      user_id
    }
    status
    expiration_date
    points
    
    approvable
    
    note_updatable
    note
  }
}`


export const UPDATE_MATCH =  gql`mutation updateMatch($id: ID!, $note: String) {
                          update_match(input: {id: $id, note: $note}) {
                            result {
                              result
                              errors{
                                field
                                message
                              }
                            }
                          }
                        }
                        `