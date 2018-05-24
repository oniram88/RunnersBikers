<template>

  <b-table striped hover
           :items="users"
           :fields="fields"
  >

    <!--<template slot="url" slot-scope="data">-->
    <!--<b-button :href="data.value" target="_blank">-->
    <!--<vf-icon icon="globe"/>-->
    <!--</b-button>-->
    <!--</template>-->

    <template slot="referal_points" slot-scope="{value,item}">
      <b-form-input :value="value"
                    @input="update_user_points(item.id,arguments[0])"
                    type="number"
                    placeholder="Punti Referal"></b-form-input>
    </template>

    <!--<template slot="created_at" slot-scope="data">-->
    <!--{{data.value | timezone | time_format}}-->
    <!--</template>-->

    <!--<template slot="points" slot-scope="data">-->
    <!--{{data.value | points_format}}-->
    <!--</template>-->


    <!--<template slot="actions" slot-scope="data">-->
    <!--<b-button target="" variant="info"-->
    <!--:v-if="data.item.editable"-->
    <!--:to="perfomance_edit_cfg(data.item)">-->
    <!--<vf-icon icon="pencil"/>-->
    <!--</b-button>-->
    <!--<b-button-->
    <!--:v-if="data.item.destructible" target="" variant="danger"-->
    <!--class="destroy_obj" @click="destroy(data.item.id)">-->
    <!--<vf-icon icon="trash"/>-->
    <!--</b-button>-->
    <!--</template>-->


  </b-table>


</template>

<script>


  import {ADMIN_USER_LIST} from "../graphql/users";

  export default {
    name: "UserList",
    data: function () {
      return {
        fields: [
          'first_name',
          'last_name',
          'referal_points'
        ],
        users: []
      }
    },
    apollo: {
      users: {
        // GraphQL Query
        query: ADMIN_USER_LIST,
        // Reactive variables
        // variables() {
        //   if (this.$route.params.user_id) {
        //     return {
        //       id: this.$route.params.user_id
        //     }
        //   } else {
        //     return {}
        //   }
        // }
      },
    },
    methods: {
      update_user_points(id, points) {
        points = parseInt(points);
        console.log(id, points);
      }
    }
  }
</script>

<style scoped>

</style>