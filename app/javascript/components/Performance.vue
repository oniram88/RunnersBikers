<style scoped lang="scss">


</style>

<template>

  <b-card title="Nuova Prestazione" class="mb-12">

    <b-form @submit.prevent="onSubmit" @reset.prevent="onReset" v-if="show">


      <b-form-group label="Distanza:"
                    :state="distance_state"
                    :feedback="distance_feedback">
        <b-form-input type="number" v-model="form.distance" required
                      :state="distance_state"
                      placeholder="Inserisci la distanza in Km"
        ></b-form-input>
      </b-form-group>

      <b-form-group label="Ritmo Medio:"
                    :state="pace_state"
                    :feedback="pace_feedback">
        <b-form-input type="text"
                      :state="pace_state"
                      v-model="form.pace" required
                      placeholder="Inserisci il ritmo in m/km 00:00"
        ></b-form-input>
      </b-form-group>

      <b-form-group label="Dislivello Positivo:" :state="positive_gain_state"
                    :feedback="positive_gain_feedback">
        <b-form-input type="number" v-model="form.positive_gain"
                      required
                      :state="positive_gain_state"
                      placeholder="Dislivello in m"
        ></b-form-input>
      </b-form-group>

      <b-form-group label="Url sito:" :state="url_state"
                    :feedback="url_feedback">
        <b-form-input type="text" v-model="form.url" required
                      :state="url_state"
                      placeholder="Url della prestazione http://....."
        ></b-form-input>
      </b-form-group>


      <b-button type="submit" variant="primary">Salva</b-button>
      <b-button type="reset" variant="secondary">Reset</b-button>
    </b-form>

    <b-alert :show="callback_message.count_down"
             dismissible
             :variant="callback_message.type"
             @dismissed="callback_message.count_down=0"
             @dismiss-count-down="dismiss_success_CountDown">
      {{callback_message.message}}
    </b-alert>
  </b-card>

</template>

<script>

  import axios from 'axios'
  import {mapStateFeedbackListCmp} from '../packs/helpers'

  export default {
    data: function () {


      return {
        form: {
          distance: null,
          pace: null,
          positive_gain: null,
          url: null
        },
        callback_message: {
          count_down: 0,
          type: 'success',
          message: 'Performance inserita correttamente'
        },
        errors: {},
        show_errors: false,
        show: true
      }
    },
    computed: {
      ...mapStateFeedbackListCmp('distance', 'pace', 'positive_gain', 'url')
    },
    watch: {
      // call again the method if the route changes
      '$route': 'load_data'
    },
    created() {
      this.load_data();
    },
    methods: {
      load_data() {
        if (this.$route.params.id) {
          this.onReset();
          axios.get(Routes.performance_path(this.$route.params.id)).then(ris => {
            console.log(ris);
            this.form = ris.data;
          });
        }
      },
      dismiss_success_CountDown(counter) {
        this.callback_message.count_down = counter;
      },
      onSubmit(evt) {
        const me = this;

        let make_action = null;

        if (this.$route.params.id) {
          make_action = axios.put(Routes.performance_path(this.$route.params.id), this.form);
        } else {
          make_action = axios.post(Routes.performances_path(), this.form);
        }


        make_action.then(ris => {
          if (ris.data.success) {
            me.callback_message.type = 'success';
            me.callback_message.message = 'Performance inserita correttamente';
            me.onReset();
            me.$router.push({name: 'performance_list'});
          } else {
            me.callback_message.type = 'danger'
            me.callback_message.message = 'Performance non valida';
          }
          me.errors = ris.data.errors;
          me.show_errors = true;

          me.callback_message.count_down = 3;
          console.log(ris);

        })
      },
      onReset() {
        // Reset our form values
        this.form.distance = null;
        this.form.pace = null;
        this.form.positive_gain = null;
        this.form.url = null;
        this.errors = {};
        this.show_errors = false;
        // Trick to reset/clear native browser form validation state
        this.show = false;
        this.$nextTick(() => {
          this.show = true
        });
      }
    }

  }
</script>
