import gql from 'graphql-tag'


export const GET_MATCHES = gql`query matches {
  matches {
    id
     
    challenger {
      first_name
      last_name
    }
    challenged {
      first_name
      last_name
    }
    challenged_performance{
      id
      user_id
      distance
      pace
      positive_gain
      url   
    }
    challenger_performance{
      id
      user_id
      distance
      pace
      positive_gain
      url 
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

export const APPROVE_MATCH =  gql`mutation approveMatch($id: ID!) {
                          approve_match(input: {id: $id}) {
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