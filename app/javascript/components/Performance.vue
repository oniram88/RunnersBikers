<style scoped lang="scss">


</style>

<template>
  <div>
    <b-form @submit.prevent="onSubmit">


      <b-form-group label="Distanza:"
                    :state="distance_state"
                    :feedback="distance_feedback">
        <b-form-input type="number" v-model="form.distance" required
                      placeholder="Inserisci la distanza in Km"
        ></b-form-input>
      </b-form-group>

      <b-form-group label="Ritmo Medio:"
                    :state="pace_state"
                    :validated="show_errors"
                    :feedback="pace_feedback">
        <b-form-input type="text"
                      :state="pace_state"
                      v-model="form.pace" required
                      placeholder="Inserisci il ritmo in m/km 00:00"
        ></b-form-input>
      </b-form-group>

      <b-form-group label="Dislivello Positivo:" :state="positive_gain_state"
                    :feedback="positive_gain_feedback">
        <b-form-input type="number" v-model="form.positive_gain" required
                      placeholder="Dislivello in m"
        ></b-form-input>
      </b-form-group>

      <b-form-group label="Url sito:" :state="url_state"
                    :feedback="url_feedback">
        <b-form-input type="text" v-model="form.url" required
                      placeholder="Url della prestazione"
        ></b-form-input>
      </b-form-group>


      <b-button type="submit" variant="primary">Submit</b-button>
      <b-button type="reset" variant="secondary">Reset</b-button>
    </b-form>

    <b-alert :show="callback_message.count_down"
             dismissible
             :variant="callback_message.type"
             @dismissed="callback_message.count_down=0"
             @dismiss-count-down="dismiss_success_CountDown">
      {{callback_message.message}}
    </b-alert>
  </div>

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
        show_errors:false
      }
    },
    computed: {
      ...mapStateFeedbackListCmp('distance', 'pace', 'positive_gain', 'url')
    },
    methods: {
      dismiss_success_CountDown(counter) {
        this.callback_message.count_down = counter;
      },
      onSubmit(evt) {
        const me = this;
        axios.post(Routes.performances_path(), this.form
        ).then(ris => {
          if (ris.data.success) {
            me.callback_message.type = 'success';
            me.callback_message.message = 'Performance inserita correttamente';
          } else {
            me.callback_message.type = 'danger'
            me.callback_message.message = 'Performance non valida';
          }
          me.errors = ris.data.errors;
          me.show_errors=true;

          me.callback_message.count_down = 3;
          console.log(ris);

        })
      }
    }

  }
</script>
