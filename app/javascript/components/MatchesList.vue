<style scoped lang="scss">

  .action {
    cursor: pointer;
  }

</style>

<template>

  <div>

    <router-view></router-view>

    <b-table striped hover
             :items="matches"
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

        <b-btn v-if="data.item.note_updatable" @click="insert_note(data.item)" class="action">
          <vf-icon icon="pencil"/>
        </b-btn>

        <b-btn @click.once="approve(data.item)" v-if="data.item.approvable"
               class="action">
          <vf-icon icon="thumbs-o-up"/>
        </b-btn>

        <b-button @click.stop="data.toggleDetails" class="mr-2" v-if="show_match_details">
          <vf-icon icon="info"/>
        </b-button>
      </template>

      <template slot="expiration_date" slot-scope="data">
        {{data.item.expiration_date | timezone | calendar}}
      </template>

      <template slot="row-details" slot-scope="row" v-if="show_match_details">
        <b-card>
          <b-row>
            <b-col v-if="row.item.challenger_performance">

              <h3>Sfidante</h3>

              <dl>
                <dt>Distanza</dt>
                <dd>{{row.item.challenger_performance.distance}}</dd>

                <dt>Ritmo Medio:</dt>
                <dd>{{row.item.challenger_performance.pace}}</dd>

                <dt>Dislivello Positivo:</dt>
                <dd>{{row.item.challenger_performance.positive_gain}}</dd>

                <dt>Url sito:</dt>
                <dd>
                  <b-link target="_blank" :href="row.item.challenger_performance.url">
                    {{row.item.challenger_performance.url}}
                  </b-link>
                </dd>
              </dl>

            </b-col>
            <b-col v-if="row.item.challenged_performance">

              <h3>Sfidato</h3>

              <dl>
                <dt>Distanza</dt>
                <dd>{{row.item.challenged_performance.distance}}</dd>

                <dt>Ritmo Medio:</dt>
                <dd>{{row.item.challenged_performance.pace}}</dd>

                <dt>Dislivello Positivo:</dt>
                <dd>{{row.item.challenged_performance.positive_gain}}</dd>

                <dt>Url sito:</dt>
                <dd>
                  <b-link target="_blank" :href="row.item.challenged_performance.url">
                    {{row.item.challenged_performance.url}}
                  </b-link>
                </dd>
              </dl>

            </b-col>
          </b-row>
          <b-button size="sm" @click="row.toggleDetails">Nascondi Dettagli</b-button>
        </b-card>
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

  import {mapState} from 'vuex'
  import {APPROVE_MATCH, GET_MATCHES, UPDATE_MATCH} from '../graphql/matches'
  import _ from 'lodash'
  import performance_element from 'components/Performance.vue'

  export default {
    name: "MatchesList",
    data: function () {
      return {
        matches: [],
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
    apollo: {
      matches: {
        query: GET_MATCHES,
        update(data) {
          return _.map(data.matches, (r) => {
            return _.extend({_showDetails: false}, r)
          });
        },
      }
    },
    watch: {
      // call again the method if the route changes
      '$route': function () {
        this.reload_matches();
      }
    },
    methods: {
      reload_matches() {
        console.log('refetch');
        this.$apollo.queries.matches.refetch()
      },
      insert_note(m) {
        this.selected_match = _.clone(m);
        this.$refs.insert_note.show();
      },
      aggiorna_match() {

        this.$apollo.mutate({
          mutation: UPDATE_MATCH,
          variables: {
            id: this.selected_match.id,
            note: this.selected_match.note
          },
          update: (store, {data: {update_match: {result}}}) => {

            if (result.result) {

              const data = store.readQuery({query: GET_MATCHES})
              const updated_match = data.matches.find(match => match.id === this.selected_match.id)
              updated_match.note = this.selected_match.note
              store.writeQuery({query: GET_MATCHES, data})

              this.selected_match = {note: null};

            }
          }
        })


      },
      approve(item) {

        this.$apollo.mutate({
          mutation: APPROVE_MATCH,
          variables: {
            id: item.id,
          }
        }).then(() => {
          this.reload_matches();
        })


      }
    },
    computed: {
      ...mapState([
        'user_roles'
      ]),
      show_match_details() {
        return _.includes(this.user_roles, 'admin') || _.includes(this.user_roles, 'judge');
      }
    }

  }
</script>
