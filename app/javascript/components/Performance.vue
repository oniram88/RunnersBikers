<style scoped lang="scss">


</style>

<template>
  <div>
    <b-form @submit.prevent="onSubmit">


      <b-form-group label="Distanza:">
        <b-form-input type="number" v-model="form.distance" required
                      placeholder="Inserisci la distanza in Km"
        ></b-form-input>
      </b-form-group>

      <b-form-group label="Ritmo Medio:">
        <b-form-input type="text" v-model="form.pace" required
                      placeholder="Inserisci il ritmo in m/km 00:00"
        ></b-form-input>
      </b-form-group>

      <b-form-group label="Dislivello Positivo:">
        <b-form-input type="number" v-model="form.positive_gain" required
                      placeholder="Dislivello in m"
        ></b-form-input>
      </b-form-group>

      <b-form-group label="Url sito:">
        <b-form-input type="text" v-model="form.url" required
                      placeholder="Url della prestazione"
        ></b-form-input>
      </b-form-group>


      <b-button type="submit" variant="primary">Submit</b-button>
      <b-button type="reset" variant="secondary">Reset</b-button>
    </b-form>
  </div>

</template>

<script>

  import axios from 'axios'

  export default {
    data: function () {
      return {
        form: {
          distance: null,
          pace: null,
          positive_gain: null,
          url: null
        }
      }
    },
    computed: {},
    methods: {
      onSubmit(evt) {
        axios.post(Routes.performances_path(), this.form
        ).then(ris => {
          console.log(ris);
        })
      }
    }

  }
</script>
