<style scoped lang="scss">

  .destroy_obj {
    cursor: pointer;
  }

</style>

<template>

  <div>
    <b-alert :show="callback_message.count_down"
             dismissible
             :variant="callback_message.type"
             @dismissed="callback_message.count_down=0"
             @dismiss-count-down="dismiss_success_CountDown">
      {{callback_message.message}}
    </b-alert>

    <router-view></router-view>


    <b-table striped hover
             :items="performances"
             :fields="fields"
    >

      <template slot="url" slot-scope="data">
        <b-button :href="data.value" target="_blank">
          <vf-icon icon="globe"/>
        </b-button>
      </template>

      <template slot="distance" slot-scope="data">
        {{data.value | distance_format}}
      </template>

      <template slot="created_at" slot-scope="data">
        {{data.value | timezone | time_format}}
      </template>

      <template slot="points" slot-scope="data">
        {{data.value | points_format}}
      </template>


      <template slot="actions" slot-scope="data">
        <b-button target="" variant="info"
                  :v-if="data.item.editable"
                  :to="perfomance_edit_cfg(data.item)">
          <vf-icon icon="pencil"/>
        </b-button>
        <b-button
            :v-if="data.item.destructible" target="" variant="danger"
            class="destroy_obj" @click="destroy(data.item.id)">
          <vf-icon icon="trash"/>
        </b-button>
      </template>


    </b-table>


  </div>

</template>

<script>

  import {mapState} from 'vuex'
  import _ from 'lodash'

  import {DELETE_PERFORMANCE, GET_PERFORMANCES} from '../graphql/performances'

  export default {
    data: function () {
      return {
        fields: [
          {
            key: 'created_at',
            sortable: true,
            label: 'Data Inserimento'
          },
          {
            key: 'distance',
            sortable: true,
            label: 'Distanza'
          },
          {
            key: 'pace',
            sortable: false,
            label: 'Ritmo'
          },
          {
            key: 'positive_gain',
            sortable: true,
            label: 'Dislivello Positivo'
          },
          {
            key: 'points',
            sortable: true,
            label: 'Punti'
          },
          {
            key: 'url',
            sortable: false,
            label: 'Link Sessione'
          },
          {
            key: 'actions',
            label: 'Azioni'
          }
        ],
        performances: [],
        callback_message: {
          count_down: 0,
          type: 'success',
          message: 'Performance inserita correttamente'
        },
      }
    },
    watch: {
      // call again the method if the route changes
      '$route': function(){
        this.$apollo.queries.performances.refetch();
      }
    },
    computed: {
      total_distance() {
        _.sumBy(this.performances, 'distance');
      },
      total_positive_gain() {
        _.sumBy(this.performances, 'positive_gain');
      },
      ...mapState([
        'user_roles'
      ])
    },
    apollo: {
      performances: {
        // GraphQL Query
        query: GET_PERFORMANCES,
        // Reactive variables
        variables() {
          if (this.$route.params.user_id) {
            return {
              id: this.$route.params.user_id
            }
          } else {
            return {}
          }
        }
      },
    },
    methods: {
      dismiss_success_CountDown(counter) {
        this.callback_message.count_down = counter;
      },
      perfomance_edit_cfg(item) {

        if (_.includes(this.user_roles, 'admin') || _.includes(this.user_roles, 'judge')) {
          return {name: 'user_performance_edit', params: {id: item.id, user_id: item.user_id}};
        } else {
          return {name: 'performance_edit', params: {id: item.id}};
        }

      },
      destroy(id) {
        this.$apollo.mutate({
          mutation: DELETE_PERFORMANCE,
          variables: {
            id: id
          }
        }).then((data) => {
          // Result

          let data_response = data.data['deletePerformance'].result

          this.errors = data_response.errors
          this.show_errors = true;

          if (data_response.result) {
            this.callback_message.type = 'success';
            this.callback_message.message ='Performance eliminata correttamente';
            this.callback_message.count_down = 3;

          } else {
            this.callback_message.type = 'danger';
            let msg = 'Problemi nella cancellazione della performance';
            if (this.base_error_obj) {
              msg += ' - ' + this.base_feedback;
            }
            this.callback_message.message = msg;
            this.callback_message.count_down = 6;

          }


        })


      }
    }

  }
</script>
