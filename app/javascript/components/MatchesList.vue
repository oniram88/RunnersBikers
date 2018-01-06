<style scoped lang="scss">

  .action {
    cursor: pointer;
  }

</style>

<template>

  <div>

    <router-view></router-view>

    <b-table striped hover
             :items="items"
             :fields="fields">

      <template slot="challenged" slot-scope="data">
        {{data.value.username}}
        <vf-icon title="Vincitore" v-if="data.item.challenged_id==data.item.winner_id" icon="diamond"/>
        <template v-if="data.item.challenged_performance">
          <b-button target="" variant="info"
                    :to="{name:'match_performance_edit',params:data.item.challenged_performance}">
            <vf-icon icon="road"/>
          </b-button>
        </template>

      </template>

      <template slot="challenger" slot-scope="data">
        <vf-icon title="Vincitore" v-if="data.item.challenger_id==data.item.winner_id" icon="diamond"/>
        {{data.value.username}}
        <template v-if="data.item.challenger_performance">
          <b-button target="" variant="info"
                    :to="{name:'match_performance_edit',params:data.item.challenger_performance}">
            <vf-icon icon="road"/>
          </b-button>
        </template>
      </template>

      <template slot="action" slot-scope="data">
        <b-btn @click="insert_note(data.item)" class="action">
          <vf-icon icon="pencil"/>
        </b-btn>
        <b-btn @click="approve(data.item)" v-if="data.item.approvable"
               class="action">
          <vf-icon icon="thumbs-o-up"/>
        </b-btn>
      </template>

      <template slot="expiration_date" slot-scope="data">
        {{data.item.expiration_date | timezone | calendar}}
      </template>


    </b-table>


    <b-modal ref="insert_note"
             @ok="aggiorna_match()"
             title="Inserisci la nota">
      <b-form-textarea v-model="selected_match.note"
                       placeholder="Nota"
                       :rows="3"
                       :max-rows="6">
      </b-form-textarea>
    </b-modal>

  </div>
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
          {
            key: 'challenger',
            label: 'Sfidante'
          },
          {
            key: 'challenged',
            label: 'Sfidato'
          },
          {
            key: 'status',
            label: 'Stato'
          },
          {
            key: 'expiration_date',
            sortable: true,
            label: 'Scadenza'
          },
          {
            key: 'points',
            label: 'Punti in gioco'
          },
          {
            key: 'action'
          }
        ],

        selected_match: {note: null}

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
      load_matches() {
        axios.get(Routes.matches_path()).then(ris => {
          this.items = ris.data;
        })
      },
      insert_note(m) {
        this.selected_match = m;
        this.$refs.insert_note.show();
      },
      aggiorna_match() {

        axios.put(Routes.match_path(this.selected_match.id), this.selected_match).then(ris => {
          if (ris.success) {
            this.load_matches();
            this.selected_match = {note: null};
          }
        });

      },
      approve(item) {
        item.approvable = false;
        axios.post(Routes.approve_match_path(item.id)).then(ris => {
          if (ris.data.success) {
            this.load_matches();
          }
        });
      }
    },
    computed: {}

  }
</script>
