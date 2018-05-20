<style scoped lang="scss">


</style>

<template>

  <b-card :title="persisted ? ( readonly ? 'Visualizza Sessione' : 'Modifica Sessione'):'Nuova Sessione' "
          class="mb-12">

    <b-form @submit.prevent="onSubmit" @reset.prevent="onReset"
            v-if="show && !readonly">


      <b-form-group label="Distanza:"
                    :state="distance_state"
                    :feedback="distance_feedback">
        <b-input-group right="km">

          <vue-numeric
              class="form-control"
              :separator="' '"
              v-model="form.distance" required
              :precision="2"
              placeholder="Inserisci la distanza in Km"
          ></vue-numeric>


        </b-input-group>
      </b-form-group>

      <b-form-group label="Ritmo Medio:"
                    :state="pace_state"
                    :feedback="pace_feedback">
        <b-input-group right="m/km" left="00:00">
          <b-form-input type="text"
                        :state="pace_state"
                        v-model="form.pace" required
                        placeholder="Inserisci il ritmo in m/km 00:00"
          ></b-form-input>
        </b-input-group>
      </b-form-group>

      <b-form-group label="Dislivello Positivo:" :state="positive_gain_state"
                    :feedback="positive_gain_feedback">
        <b-input-group right="m">
          <b-form-input type="number" v-model.number="form.positive_gain"
                        :state="positive_gain_state" required
                        placeholder="Dislivello in m"
          ></b-form-input>
        </b-input-group>
      </b-form-group>

      <b-form-group label="Url sito:" :state="url_state"
                    :feedback="url_feedback">
        <b-form-input type="text" v-model="form.url" required
                      :state="url_state"
                      placeholder="Url della sessione http://....."
        ></b-form-input>
      </b-form-group>


      <b-button type="submit" variant="primary" :disabled="disabled_save">
        Salva
      </b-button>
      <b-button type="reset" variant="secondary" v-if="!reset_disabled">Reset
      </b-button>
    </b-form>

    <b-row v-else="">
      <b-col>
        <dl>
          <dt>Distanza</dt>
          <dd>{{form.distance}}</dd>

          <dt>Ritmo Medio:</dt>
          <dd>{{form.pace}}</dd>

          <dt>Dislivello Positivo:</dt>
          <dd>{{form.positive_gain}}</dd>

          <dt>Url sito:</dt>
          <dd>
            <b-link :href="form.url">{{form.url}}</b-link>
          </dd>
        </dl>
      </b-col>
    </b-row>

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

  import {mapStateFeedbackListCmp} from '../packs/helpers'
  import {EDIT_PERFORMANCE, CREATE_PERFORMANCE, GET_PERFORMANCE} from '../graphql/performances'

  export default {
    data: function () {


      return {
        readonly: false,
        disabled_save: false,
        form: {
          distance: 0,
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
    apollo: {
      performance: {
        // GraphQL Query
        query: GET_PERFORMANCE,
        // Reactive variables
        variables() {
          return {
            id: this.$route.params.id
          }
        },
        // Disable the query
        skip() {
          return !this.persisted
        },
        update(data) {
          this.readonly = data.performance.readonly;

          console.log(data);
          this.form.distance = data.performance.distance
          this.form.pace = data.performance.pace
          this.form.positive_gain = data.performance.positive_gain
          this.form.url = data.performance.url

        }
      }
    },
    computed: {
      ...mapStateFeedbackListCmp('distance', 'pace', 'positive_gain', 'url', 'base'),

      reset_disabled() {
        return this.$route.params.id;
      },

      persisted() {
        return !!this.$route.params.id;
      }

    },
    watch: {
      // call again the method if the route changes
      '$route': 'load_data'
    },
    created() {
      this.load_data();
    },
    methods: {
      set_correct_decimal() {
        this.form.distance = this.form.distance.replace(',', '.')
      },
      load_data() {
        if (this.$route.params.id) {
          this.readonly = true;
          this.onReset();
        } else {
          this.onReset();
        }
      },
      dismiss_success_CountDown(counter) {
        this.callback_message.count_down = counter;
      },
      onSubmit() {
        const me = this;

        const {distance, pace, positive_gain, url} = this.form

        let variables = {
          distance,
          pace,
          positive_gain,
          url
        }
        let mutation = CREATE_PERFORMANCE


        if (this.persisted) {
          variables.id = this.$route.params.id
          mutation = EDIT_PERFORMANCE
        }


        this.$apollo.mutate({
          mutation: mutation,
          variables: variables
        }).then((data) => {
          // Result

          let data_response = data.data[this.persisted ? 'editPerformance' : 'createPerformance'].result

          this.errors = data_response.errors
          this.show_errors = true;

          if (data_response.result) {
            this.callback_message.type = 'success';
            this.callback_message.message = this.persisted ? 'Performance aggiornata correttamente' : 'Performance creata correttamente';
            this.callback_message.count_down = 3;
            setTimeout(() => {
              if (this.$route.params.user_id) {
                this.$router.push({name: 'user_performance_list', params: {user_id: this.$route.params.user_id}})
              } else {
                this.$router.push({name: 'performance_list'})
              }

            }, 1500);
          } else {
            me.callback_message.type = 'danger';
            let msg = 'Performance non valida';
            if (this.base_error_obj) {
              msg += ' - ' + this.base_feedback;
            }
            me.callback_message.message = msg;
            me.callback_message.count_down = 6;

          }


        })


      },
      onReset() {
        // Reset our form values
        this.form.distance = 0;
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
