<template>

  <b-row>
    <b-col>

      <carousel :autoplay="true" :perPage="1" :loop="true" :paginationEnabled="false">

        <slide>
          <b-card>
            Numero di Km Totali Corsi: {{statistics.total_distance}} km
          </b-card>
        </slide>
        <slide>
          <b-card>
            Totale Dislivello guadagnato: {{statistics.total_positive_gain}} m
          </b-card>
        </slide>
        <slide>
          <b-card>
            Tempo totale di corsa: {{total_run_duration}}
          </b-card>
        </slide>

      </carousel>

    </b-col>
  </b-row>


</template>

<script>

  import {STATISTICS} from "../graphql/rankings";
  import moment from 'moment'
  import { Carousel, Slide } from 'vue-carousel';

  export default {
    name: "Statistics",
    components:{
      Carousel,
      Slide
    },
    apollo: {
      statistics: STATISTICS
    },
    data: function () {
      return {
        statistics: {
          total_distance: null,
          total_positive_gain: null,
          total_run_time: null
        }
      }
    },
    computed:{
      total_run_duration(){
        return moment.duration(this.statistics.total_run_time, 'seconds').locale("it").humanize();
      }
    }
  }
</script>

<style scoped>

</style>