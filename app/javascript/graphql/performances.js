import gql from 'graphql-tag'

export const CREATE_PERFORMANCE = gql`mutation createPerformance($distance: Float, $pace: String, $positive_gain: Int, $url: String) {
                          createPerformance(input: {distance: $distance, pace: $pace, positive_gain: $positive_gain, url: $url}) {
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

export const EDIT_PERFORMANCE =  gql`mutation editPerformance($id: ID!, $distance: Float, $pace: String, $positive_gain: Int, $url: String) {
                          editPerformance(input: {id: $id, distance: $distance, pace: $pace, positive_gain: $positive_gain, url: $url}) {
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

export const DELETE_PERFORMANCE =  gql`mutation deletePerformance($id: ID!) {
                          deletePerformance(input: {id: $id}) {
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

export const GET_PERFORMANCE =  gql`query getPerformance($id:ID!){
  performance(id:$id){
    distance
    pace
    readonly
    url
    positive_gain
  }
}`

export const GET_PERFORMANCES =  gql`query getPerformances($id:ID){
  performances(user_id:$id){
    distance
    pace
    url
    positive_gain
    created_at
    editable
    destructible
    user_id
    id
  }
}
`
