import gql from 'graphql-tag'

export const RANKING_LIST =  gql`{
        rankings {
          total_distance
          id
          first_name
          last_name
          total_points
          total_positive_gain
          rank
          challenged
          machable
          max_lose_points
          show_performances
        }
      }`


export const CREATE_MATCH = gql`mutation createMatch($challenged_id:ID!,$points:Int){
                          createMatch(input:{challenged_id:$challenged_id,points:$points}){
                            result{
                              result
                            }
                          }
                        }
                        `