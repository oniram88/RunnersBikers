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
        <b-button @click="show_modal(data.item)" v-if="data.item.machable"
                  target="_blank" class="create_match_btn">
          <vf-icon icon="fort-awesome"/>
        </b-button>
      </template>
    </b-table>

    <b-modal title="Nuovo match" ref="modal_match" @ok="invio_match"
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
                         :step="100"
                         v-model="match.points"/>
        </b-form-group>

      </b-form>


    </b-modal>
  </div>

</template>

<script>

  import axios from 'axios';
  import _ from 'lodash';

  export default {
    data: function () {
      return {
        match: {
          points: 0,
          challenged_id: null,
          max_lose_points: 100
        },
        items: [],
        fields: [
          {
            label: 'Rank',
            key: 'rank',
            sortable: true
          },
          {
            key: 'email',
            sortable: true,
            label: 'Email'
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
      this.load_ranking();
    },
    watch: {
      // call again the method if the route changes
      '$route': 'load_ranking'
    },
    computed: {
      rank_calculator() {

      },
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
        this.$refs.modal_match.show();
      },
      load_ranking() {
        axios.get(Routes.ranking_index_path()).then(ris => {
          this.items = ris.data;
        })
      },
      invio_match() {
        console.log(this.match.points);
        axios.post(Routes.matches_path(), {match: this.match}).then(ris => {
          console.log(ris);
        });
      },
      reset_match() {
        this.match.points = 0;
        this.match.challenged_id = null;
      }
    }

  }
</script>
