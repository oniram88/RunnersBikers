<style scoped lang="scss">

  .destroy_obj {
    cursor: pointer;
  }

</style>

<template>

  <div>

    <router-view></router-view>


    <b-table striped hover
             :items="items"
             :fields="fields"
    >

      <template slot="url" slot-scope="data">
        <b-button :href="data.value" target="_blank">
          <vf-icon icon="globe"/>
        </b-button>
      </template>


      <template slot="actions" slot-scope="data">
        <b-button target="" variant="info"
                  :to="{name:'performance_edit',params:{id:data.item.id}}">
          <vf-icon icon="pencil"/>
        </b-button>
        <b-button :disabled="!data.item.destroyable" target="" variant="danger"
                  class="destroy_obj" @click="destroy(data.item.id)">
          <vf-icon icon="trash"/>
        </b-button>
      </template>


    </b-table>


  </div>

</template>

<script>

  import axios from 'axios'
  import moment from 'moment'
  import _ from 'lodash'

  export default {
    data: function () {
      return {
        fields: [
          {
            key: 'created_at',
            sortable: true,
            label: 'Data Inserimento',
            formatter: value => {
              return moment(value).format('l');
            }
          },
          {
            key: 'distance',
            sortable: true,
            label: 'Distanza'
          },
          {
            key: 'pace',
            sortable: false,
            label: 'Ritmo'
          },
          {
            key: 'positive_gain',
            sortable: true,
            label: 'Dislivello Positivo'
          },
          {
            key: 'url',
            sortable: false,
            label: 'Link Prestazione'
          },
          {
            key: 'actions',
            label: 'Azioni'
          }
        ],
        items: []
      }
    },
    created: function () {
      this.load_performances();
    },
    computed: {
      total_distance() {
        _.sumBy(this.items, 'distance');
      },
      total_positive_gain() {
        _.sumBy(this.items, 'positive_gain');
      }
    },
    methods: {
      load_performances() {
        axios.get(Routes.performances_path()).then(ris => {
          console.log(ris);
          this.items = ris.data;
        })
      },
      destroy(id) {
        console.log(id);
      }
    }

  }
</script>
