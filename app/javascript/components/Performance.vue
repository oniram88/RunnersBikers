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
              v-model="form.distance"
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

  import axios from 'axios'
  import {mapStateFeedbackListCmp} from '../packs/helpers'
  import gql from 'graphql-tag'
  import {EDIT_PERFORMANCE} from '../graphql/performances'

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
          this.$authorize('performance', 'update?', this.$route.params.id).then((ris) => {
            this.readonly = !ris;
          });

          this.onReset();

          let path = Routes.performance_path(this.$route.params.id);

          if (this.$route.params.user_id) {
            path = Routes.user_performance_path(this.$route.params.user_id, this.$route.params.id)
          }


          axios.get(path).then(ris => {
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

        // this.disabled_save = true;
        let make_action = null;

        // if (this.persisted) {
        //
        //   let path = Routes.performance_path(this.$route.params.id);
        //
        //   if (this.$route.params.user_id) {
        //     path = Routes.user_performance_path(this.$route.params.user_id, this.$route.params.id)
        //   }
        //
        //   make_action = axios.put(path, this.form);
        //
        // } else {
        //   make_action = axios.post(Routes.performances_path(), this.form);
        // }
        //
        //
        // make_action.then(ris => {
        //   if (ris.data.success) {
        //     me.callback_message.type = 'success';
        //     me.callback_message.message = 'Performance inserita correttamente';
        //     me.callback_message.count_down = 3;
        //     me.onReset();
        //     setTimeout(() => {
        //       if (this.$route.params.user_id) {
        //         me.$router.push({name: 'user_performance_list', params: {user_id: this.$route.params.user_id}})
        //       } else {
        //         me.$router.push({name: 'performance_list'})
        //       }
        //
        //     }, 1500);
        //   } else {
        //     me.callback_message.type = 'danger';
        //     let msg = 'Performance non valida';
        //     if (ris.data.errors.base) {
        //       msg += ' - ' + ris.data.errors.base[0];
        //     }
        //     me.callback_message.message = msg;
        //     me.callback_message.count_down = 6;
        //   }
        //   me.errors = ris.data.errors;
        //   me.show_errors = true;
        //   me.disabled_save = false;
        //
        // })

        if (this.persisted) {
          const {distance, pace, positive_gain, url} = this.form

          this.$apollo.mutate({
            mutation: EDIT_PERFORMANCE,
            variables: {
              id: this.$route.params.id,
              distance,
              pace,
              positive_gain,
              url
            }
          }).then((data) => {
            // Result
            console.log(data)
            this.errors = data.data.editPerformance.result.errors
            this.show_errors = true;

            if (data.data.editPerformance.result.result) {
              this.callback_message.type = 'success';
              this.callback_message.message = 'Performance aggiornata correttamente';
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
        } else {

        }


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
