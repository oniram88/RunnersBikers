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
            v-if="data.item.show_performances"
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

  import _ from 'lodash';
  import {CREATE_MATCH, RANKING_LIST} from "../graphql/rankings";

  export default {
    apollo: {
      rankings: RANKING_LIST
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
      // '$route': 'load_ranking'
    },
    computed: {
      items: function () {
        return _.map(this.rankings, ele => {
          return _.extend({_rowVariant: (ele.challenged ? 'warning' : 'default')}, ele);
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
      invio_match() {


        // Call to the graphql mutation
        this.$apollo.mutate({
          // Query
          mutation: CREATE_MATCH,
          // Parameters
          variables: this.match,
          refetchQueries: [{
            query: RANKING_LIST,
          }]
        })
        //   .then((data) => {
        //   console.log('then', data);
        // }).catch((error) => {
        //   console.error(error)
        // })

      },

      reset_match() {
        this.match.points = 0;
        this.match.challenged_id = null;
      }
    }

  }
</script>
