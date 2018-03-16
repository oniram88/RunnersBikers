<style scoped lang="scss">
  .create_match_btn {
    cursor: pointer;
  }

  .slider_width /deep/ .slider.slider-horizontal {
    width: 400px;
  }

</style>

<template>
  <div>
    <b-table striped hover
             :items="items"
             :fields="fields"
    >
      <template slot="actions" slot-scope="data">
        <b-button
            v-authorize:user.show_performances?="data.item.id"
            :to="{name:'user_performance_list',params:{user_id:data.item.id}}"
            class="create_match_btn">
          <vf-icon icon="list"/>
        </b-button>
        <b-button @click="show_modal(data.item)" v-if="data.item.machable"
                  target="_blank" class="create_match_btn" title="Crea Sfida">
          <vf-icon icon="crosshairs"/>
        </b-button>

      </template>

      <template slot="total_distance" slot-scope="data">
        {{data.value | distance_format}}
      </template>

      <template slot="total_points" slot-scope="data">
        {{data.value | points_format}}
      </template>
    </b-table>

    <b-modal title="Punteggio Sfida" ref="modal_match" @ok="invio_match"
             @cancel="reset_match">


      <b-form>

        <b-form-group label="Punti:">
          <b-form-input
              type="number"
              readonly
              :value="match.points"
              required
              placeholder="Inserisci i punti da rubare">
          </b-form-input>
          <b-form-slider class="slider_width" :min="1"
                         tooltip="always"
                         :max="match.max_lose_points"
                         :step="1"
                         v-model="match.points"/>
        </b-form-group>

      </b-form>


    </b-modal>
  </div>

</template>

<script>

  import axios from 'axios';
  import _ from 'lodash';
  import gql from 'graphql-tag'

  export default {
    apollo: {
      rankings: gql`{
        rankings {
          total_distance
          id
          username
          total_points
          total_positive_gain
          rank
          challenged
          machable
          max_lose_points
        }
      }`
    },
    data: function () {
      return {
        match: {
          points: 0,
          challenged_id: null,
          max_lose_points: 100
        },
        rankings: [],
        fields: [
          {
            label: 'Rank',
            key: 'rank',
            sortable: true
          },
          {
            key: 'username',
            sortable: true,
            label: 'Utente'
          },
          {
            key: 'total_points',
            sortable: true,
            label: 'Punti totali'
          },
          {
            key: 'total_distance',
            sortable: true,
            label: 'Distanza Totale (Km)'
          },
          {
            key: 'total_positive_gain',
            sortable: true,
            label: 'Dislivello positivo complessivo'
          },
          {
            label: '',
            key: 'actions'
          }
        ]
      }
    },
    created: function () {
      // this.load_ranking();
    },
    watch: {
      // call again the method if the route changes
      '$route': 'load_ranking'
    },
    computed: {
      items: function () {
        return _.map(this.rankings, ele => {
          return _.extend({_rowVariant: (ele.challanged ? 'warning' : 'default')}, ele);
        });
      }
    },
    methods: {
      check_min_value(max, value) {
        if (max < parseInt(value)) {
          this.match.points = max;
        }
        if (parseInt(value) < 0) {
          this.match.points = 0;
        }
      },
      show_modal(dati) {
        console.log(dati);
        this.match.max_lose_points = dati.max_lose_points;
        this.match.challenged_id = dati.id;
        this.match.points = 0;
        this.$refs.modal_match.show();
      },
      // load_ranking() {
      //   axios.get(Routes.ranking_index_path()).then(ris => {
      //     this.items = _.map(ris.data, ele => {
      //       ele._rowVariant = (ele.challanged ? 'warning' : 'default');
      //       return ele;
      //     });
      //   })
      // },
      invio_match() {


        // Call to the graphql mutation
        this.$apollo.mutate({
          // Query
          mutation: gql`mutation createMatch($challenged_id:ID!,$points:Int){
                          createMatch(input:{challenged_id:$challenged_id,points:$points}){
                            result{
                              result
                            }
                          }
                        }
                        `,
          // Parameters
          variables: this.match,
          // Update the cache with the result
          // The query will be updated with the optimistic response
          // and then with the real result of the mutation
          update: (store, {data: {newTag}}) => {


            console.log('quando appare questo?',arguments);

            // // Read the data from our cache for this query.
            // const data = store.readQuery({query: TAGS_QUERY})
            // // Add our tag from the mutation to the end
            // data.tags.push(newTag)
            // // Write our data back to the cache.
            // store.writeQuery({query: TAGS_QUERY, data})
          },
          // Optimistic UI
          // Will be treated as a 'fake' result as soon as the request is made
          // so that the UI can react quickly and the user be happy
          // optimisticResponse: {
          //   __typename: 'Mutation',
          //   addTag: {
          //     __typename: 'Tag',
          //     id: -1,
          //     label: newTag,
          //   },
          // },
        }).then((data) => {
          // Result
          console.log(data)
        }).catch((error) => {
          // Error
          console.error(error)
          // We restore the initial user input
          // this.newTag = newTag
        })
        //
        //
        // console.log(this.match.points);
        // axios.post(Routes.matches_path(), {match: this.match}).then(ris => {
        //   // this.load_ranking();
        //   this.reset_match();
        // });
      },
      reset_match() {
        this.match.points = 0;
        this.match.challenged_id = null;
      }
    }

  }
</script>
