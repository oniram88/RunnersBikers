<template>

  <b-row>
    <b-col>

      <carousel :autoplay="true" :perPage="2" :loop="true" :paginationEnabled="false" :autoplayTimeout="3000">

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

        <slide>
          <b-card>
            Dislivello più alto singola sessione: {{statistics.max_positive_gain_in_a_session}}
          </b-card>
        </slide>


        <slide>
          <b-card>
           Percorso più lungo singola sessione: {{statistics.max_distance_in_a_session}}
          </b-card>
        </slide>
        <slide>
          <b-card>
            Velocità media più alta singola sessione: {{statistics.max_average_speed_in_a_session}}
          </b-card>
        </slide>
        <slide>
          <b-card>
            utente con più sessioni: {{statistics.user_with_max_sessions}}
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
          max_average_speed_in_a_session:null,
          max_distance_in_a_session:null,
          max_positive_gain_in_a_session:null,
          user_with_max_sessions:null,
          total_run_time:null,
          total_positive_gain:null,
          total_distance:null
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