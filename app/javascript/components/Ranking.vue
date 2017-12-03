<style scoped lang="scss">


</style>

<template>
  <b-table striped hover
           :items="items"
           :fields="fields"
  >
  </b-table>
</template>

<script>

  import axios from 'axios';
  import _ from 'lodash';

  export default {
    data: function () {
      return {
        items: [],
        fields: [
          {
            label: 'Rank',
            key:'rank',
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
      load_ranking() {
        axios.get(Routes.ranking_index_path()).then(ris => {
          this.items = ris.data;
          let rank=1;
          _.each(_.reverse(_.sortBy(this.items, el=>el.total_points)),el=>{
            el.rank=rank; 
            rank+=1;
          });
        })
      }
    }

  }
</script>
