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