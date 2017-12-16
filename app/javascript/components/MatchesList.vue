<style scoped lang="scss">


</style>

<template>
  <b-table striped hover
         :items="items"
         :fields="fields"></b-table>

</template>

<script>

  import axios from 'axios';
  import _ from 'lodash';

  export default {
    name: "MatchesList",
    data: function () {
      return {
        items: [],
        fields: [
          'challenged_id',
          'challenger_id'
        ]
      }
    },
    created: function () {
      this.load_matches();
    },
    watch: {
      // call again the method if the route changes
      '$route': 'load_matches'
    },
    methods: {
      load_matches(){
        axios.get(Routes.matches_path()).then(ris => {
          this.items = ris.data;
        })
      }
    },
    computed: {}

  }
</script>
