import gql from "graphql-tag";

export const ADMIN_USER_LIST = gql`query users{
  users{
    id
    first_name
    last_name
    referal_points
  }
}`

export const SET_REFERAL_POINTS = gql`mutation set_referal_points($id:ID!,$points:Int!){
    set_referal_points(input:{user_id:$id,points:$points}){
      result{
        result
      }
    }
  }`