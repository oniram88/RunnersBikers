import gql from "graphql-tag";

export const ADMIN_USER_LIST =  gql`query users{
  users{
    id
    first_name
    last_name
    referal_points
  }
}`