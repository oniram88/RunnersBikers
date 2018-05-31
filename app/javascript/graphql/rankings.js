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

export const STATISTICS =  gql`{
        statistics{
          max_average_speed_in_a_session
          max_distance_in_a_session
          max_positive_gain_in_a_session
          user_with_max_sessions
          total_run_time
          total_positive_gain
          total_distance
        }
      }`
